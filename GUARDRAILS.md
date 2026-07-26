# GUARDRAILS

**Edit this file. These five are a starting set, not a standard.** They exist so that
`/inspect` has something concrete to grade against — an inspector with no guardrail list
falls back to taste, and taste is exactly what this repo is trying to replace.

Keep them short enough to remember and specific enough to violate. A guardrail you can't
imagine breaching isn't a guardrail, it's a slogan.

---

**A — Original work is never destroyed.**
Never delete or overwrite anything that could hold original work: project files, notes,
evidence folders, docs, screenshots with unique content. When cleaning, produce the exact
list of paths first, delete only from that reviewed list, and prefer moving to trash over
`rm`.

**B — Machine health is never traded for speed.**
No system settings changes, no launch daemons, nothing that fights the OS's own memory
management.

**C — Git-first safety.**
Before touching any repo: clean status check, confirm the remote is pushed. No force-push,
no history rewrites, no remote deletions.

**D — Accounts, subscriptions and purchases are human-only.**
Agents produce checklists with exact steps and dates. They never attempt a cancellation,
rename, or purchase themselves.

**E — Secrets are scanned, not trusted.**
Run a secret scanner (`gitleaks protect --staged`) before any commit touching config or
auth. "It's just a config file" is how keys ship.

---

## How a breach is treated

> **A breach counts even if nothing broke.**

Near-misses are the only cheap lessons available; waiting for damage to teach you is how the
expensive ones get learned. See [TIERS.md](TIERS.md) — any breach demotes the job type one
tier, same day.
