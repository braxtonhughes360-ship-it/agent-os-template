#!/bin/zsh
# health-canary.sh — daily check that your agent setup is still standing.
#
# Appends ONE line to HEALTH_LOG.md in this repo. On any failure it writes the
# failure block at the TOP of the log, because a failure buried under 200 OK
# lines is a failure nobody reads.
#
# Run by hand any time:   bin/health-canary.sh
# Run daily on macOS:     launchd (see README). On Linux: cron.
# Exit code: 0 all clear, 1 one or more checks failed.
#
# Checks 1–2 are OPTIONAL tool checks: they only run if you use those tools,
# and they record "skipped" — never a false OK — when you don't. Edit them to
# match your own setup; the point of a canary is that it checks YOUR wiring.

emulate -L zsh
setopt pipe_fail

# Repo root = one level up from this script. No hardcoded paths.
typeset -g OS_DIR="${0:A:h:h}"
typeset -g LOG="$OS_DIR/HEALTH_LOG.md"
typeset -g STAMP="$(date '+%Y-%m-%d %H:%M')"
typeset -ga FAILURES=()
typeset -ga OKS=()
typeset -ga SKIPS=()
typeset PYBIN="$(command -v python3)"

fail() { FAILURES+=("$1"); }
ok()   { OKS+=("$1"); }
skip() { SKIPS+=("$1"); }

# ── 1. (optional) agent hooks still wired ─────────────────────────────────────
# Wiring is what silently rots. Checks every Claude config dir that exists.
# If you don't use hooks, this records "skipped" and moves on.
typeset -a CFG_DIRS=("$HOME/.claude"(N) "$HOME/.claude-"*(N/))
typeset hook_checked=0
for dir in $CFG_DIRS; do
  typeset cfg="$dir/settings.json"
  [[ -f "$cfg" ]] || continue
  # Only assert on configs that mention hooks at all.
  grep -q '"hooks"' "$cfg" 2>/dev/null || continue
  hook_checked=1
  "$PYBIN" - "$cfg" <<'PY' >/dev/null 2>&1
import json, sys
h = json.load(open(sys.argv[1])).get("hooks", {})
# A hook entry with an empty or missing command is broken wiring.
bad = [x for entries in h.values() for entry in (entries or [])
       for x in (entry.get("hooks") or []) if not x.get("command")]
raise SystemExit(1 if bad else 0)
PY
  if [[ $? -eq 0 ]]; then ok "hooks/${dir:t}"; else fail "hooks/${dir:t}: hook entry with empty command"; fi
done
(( hook_checked )) || skip "hooks (none configured)"

# ── 2. (optional) statusline script healthy ───────────────────────────────────
# Not just "exists" — feed it a real payload and require a non-empty line back.
typeset SL="$HOME/bin/claude-statusline.sh"
if [[ -x "$SL" ]]; then
  typeset out
  out=$(print '{"model":{"display_name":"canary"},"workspace":{"current_dir":"/tmp"}}' | "$SL" 2>/dev/null)
  if [[ -n "$out" ]]; then ok "statusline"; else fail "statusline: produced no output on a valid payload"; fi
else
  skip "statusline (not installed)"
fi

# ── 3. disk free > 50GB ───────────────────────────────────────────────────────
typeset -i FREE_GB
FREE_GB=$(df -g / | awk 'NR==2 {print $4}')
if (( FREE_GB > 50 )); then ok "disk ${FREE_GB}GB free"; else fail "disk: only ${FREE_GB}GB free (want >50GB)"; fi

# ── 4. (macOS) memory pressure normal ─────────────────────────────────────────
# Read-only sample. Never changes anything.
if command -v memory_pressure >/dev/null 2>&1; then
  typeset -i FREEPCT
  FREEPCT=$(memory_pressure 2>/dev/null | awk -F': ' '/free percentage/ {gsub(/%/,"",$2); print $2+0}')
  if (( FREEPCT >= 15 )); then ok "memory ${FREEPCT}% free"; else fail "memory: only ${FREEPCT}% free (want >=15%)"; fi
else
  skip "memory (no memory_pressure on this OS)"
fi

# ── 5. no repo has drifted into a cloud-synced folder ─────────────────────────
# iCloud Desktop&Documents sync corrupts builds and git state. This catches a
# repo being cloned into the bad place months from now.
typeset -a DRIFT
DRIFT=("${(@f)$(find "$HOME/Documents" -maxdepth 3 -name .git -type d 2>/dev/null | sed 's|/.git$||')}")
DRIFT=("${(@)DRIFT:#}")
if (( ${#DRIFT} == 0 )); then
  ok "no repos under ~/Documents"
else
  fail "cloud drift: ${#DRIFT} repo(s) under ~/Documents — ${(j:, :)${(@)DRIFT##*/}}"
fi

# ── 6. secret scanner installed ───────────────────────────────────────────────
if command -v gitleaks >/dev/null 2>&1; then ok "gitleaks"; else fail "gitleaks: not on PATH — secret scanning is dead"; fi

# ── 7. ledger updated within 7 days ───────────────────────────────────────────
# A stale ledger means work is running ungraded — the exact drift this whole
# system exists to prevent.
typeset LEDGER="$OS_DIR/AUTONOMY_LEDGER.md"
if [[ ! -f "$LEDGER" ]]; then
  fail "ledger: $LEDGER missing"
else
  typeset -i AGE_D MTIME
  MTIME=$(stat -f %m "$LEDGER" 2>/dev/null || stat -c %Y "$LEDGER" 2>/dev/null)
  AGE_D=$(( ( $(date +%s) - MTIME ) / 86400 ))
  if (( AGE_D <= 7 )); then ok "ledger ${AGE_D}d old"; else fail "ledger: ${AGE_D} days since last update (want <=7) — work is running ungraded"; fi
fi

# ── write the log ─────────────────────────────────────────────────────────────
[[ -f "$LOG" ]] || {
  print -- "# HEALTH LOG\n\nAppended by \`bin/health-canary.sh\`.\nFailures are written at the TOP so they cannot be buried.\n\n---\n" > "$LOG"
}

typeset SKIPNOTE=""
(( ${#SKIPS} )) && SKIPNOTE=" · skipped: ${(j: · :)SKIPS}"

if (( ${#FAILURES} == 0 )); then
  print -- "- \`$STAMP\` **OK** · ${(j: · :)OKS}${SKIPNOTE}" >> "$LOG"
  exit 0
fi

# Failure: hoist the block to the top of the log.
typeset BLOCK="## ⚠ FAILURE $STAMP

$(for f in $FAILURES; do print -- "- **$f**"; done)

Passed: ${(j: · :)OKS}${SKIPNOTE}

"
typeset TMP="${TMPDIR:-/tmp}/health-canary.$$"
{
  # keep the title block, insert the failure right after it
  head -7 "$LOG"
  print -- "$BLOCK"
  tail -n +8 "$LOG"
} > "$TMP" && mv "$TMP" "$LOG"

print -- "- \`$STAMP\` **FAIL** · ${(j: · :)FAILURES}${SKIPNOTE}" >> "$LOG"

exit 1
