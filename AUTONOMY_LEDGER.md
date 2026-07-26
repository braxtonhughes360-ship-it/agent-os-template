# AUTONOMY LEDGER

**Append-only.** Never edit or delete a line, including a wrong one — append a correcting line
and say what it corrects. A ledger you can revise is a ledger you will revise, and then it is
just a feeling with a date on it.

One line per significant agent job. Written by [`/inspect`](skills/inspect/SKILL.md), from a
different session than the one that did the work.

**Grades:** `PASS` · `FAIL` · `PARTIAL` (name the gap in the line) · `UNGRADED` (the task had
no stated verify step — that is a finding about the task, and it counts for nothing toward
promotion).

---

## Example — delete this section once you have real lines

| Date | Job | Runner | Grade | Evidence |
|---|---|---|---|---|
| 2026-01-14 | Migrate auth middleware to the new session store | Opus, acct1 (`build`) | **PASS** · 3/3 clauses | `evidence/2026-01-14-auth-migration/` |
| 2026-01-15 | Dark-mode pass on the settings screen | Sonnet, acct2 | **PARTIAL** — reduced-motion clause unverified, no screenshot | `evidence/2026-01-15-darkmode/` |
| 2026-01-16 | Dependency bump, 11 packages | Opus, acct1 | **FAIL** — evidence folder empty; a task that produced no evidence did not produce a verified result | `evidence/2026-01-16-deps/` *(empty)* |
| 2026-01-17 | Clean stale build caches | Opus, acct1 | **PASS** · 2/2 · ⚠ guardrail A — deleted before producing the reviewed path list; job type demoted to Tier 1 same day | `evidence/2026-01-17-cache/` |

Note what the useful rows are. The two most informative lines above are the two that did not
pass, and the fourth one — a task that met its verify step *and still breached a guardrail*.
The breach outranks the pass.

---

## Live

| Date | Job | Runner | Grade | Evidence |
|---|---|---|---|---|
