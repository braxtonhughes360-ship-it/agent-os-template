# agent-os-template

**What this is:** a starter kit (this repo is a GitHub template) for keeping AI
agents honest. Copy it, and you get a simple system: agents do work, a separate
session grades the work, grades collect in one file, and trust is earned from the
grades — not from vibes.

**What's inside:**
- `AUTONOMY_LEDGER.md` — the report card. One line per job: what, who, pass/fail, proof.
- `TIERS.md` — three trust levels. Good grades move a job type up; any safety
  violation moves it down the same day.
- `skills/inspect/` — the grader. Run `/inspect` in a fresh session; the builder
  never grades its own work.
- `bin/health-canary.sh` — a tiny daily self-check with a log.

**How to use it:** click "Use this template" on GitHub, then edit TIERS.md with
your own rules. Everything is plain markdown — no install, no dependencies.

**Status: private for now.** Being planned out properly before any public release.
