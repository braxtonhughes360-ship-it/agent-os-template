# TIERS — earned autonomy

**This is policy for the human and a standing instruction agents read. It is not enforcement
code.** Nothing in this repo can stop an agent doing anything. What it can do is make the
decision to trust an agent *a recorded one* instead of a mood.

A **job type** is a kind of work, not a repo: "UI component", "migration", "config/hygiene",
"dependency bump", "decision doc". Tiers attach to job types because that is where competence
actually generalizes — an agent that is reliable at dependency bumps has told you nothing
about how it handles a schema migration.

---

## The three tiers

| Tier | What the human reviews | What the agent may do unattended |
|---|---|---|
| **1 · Supervised** | **Every diff**, before it is committed | Nothing lands without a read |
| **2 · Checkpointed** | **At task boundaries** — the diff for a whole task, not each edit | Work a whole task, then stop and present |
| **3 · Autonomous** | **The report only** — plus spot-checks whenever you feel like it | Work the task and self-report; you read the summary and the evidence path |

Every job type starts at **Tier 1**. Nothing starts trusted.

## Promotion

> A job type moves up **one** tier after **20 graded passes at ≥95%**.

- "Graded" means an `/inspect` run appended a ledger line. **Ungraded work does not count**,
  no matter how well it went. This is deliberate: the cost of promotion is the discipline of
  grading, and a job type nobody bothers to grade has not earned anything.
- "≥95%" is over the **last 20 graded runs** of that job type — 19 of 20 passing. A rolling
  window, not a lifetime average, so a job type cannot coast on old wins.
- Promotion is never automatic. It is a human reading the ledger and deciding. The rule tells
  you when you are *allowed* to promote, not when you *must*.

Twenty is not a magic number. It is large enough that a lucky streak won't clear it and small
enough to actually reach. Pick your own — but pick it **before** you start, not on the day
you're tempted to promote something.

## Demotion

> **ANY guardrail breach demotes the job type one tier immediately.**

Immediately means the same day, before the next task of that type runs. No discussion, no
"it was almost fine", no waiting for a pattern. One breach, one tier down.

The guardrails are the ones in [GUARDRAILS.md](GUARDRAILS.md) — yours, not mine.

**Two demotions of the same job type inside 30 days sends it back to Tier 1**, regardless of
where it had climbed. Repeated breaches are a signal about the job type's fit for autonomy,
not bad luck.

## The one rule that makes the rest work

> **The builder never grades its own work.**

The agent that wrote the task does not decide whether it passed. `/inspect` runs separately —
a different session at minimum, a different account or a different model for anything that
matters. An agent grading itself will find its own work acceptable; that is not dishonesty,
it is the same context producing the same blind spot twice.

This is the manager–inspector split. The manager makes the thing. The inspector reads the
stated verify step, reads the diff, and writes a line that will still be true in six months.

## Current tiers

Keep this table honest, including when it is embarrassing. A tier table that only moves up is
a table nobody is reading.

| Job type | Tier | Graded passes | Notes |
|---|---|---|---|
| *(add yours)* | 1 · Supervised | 0 | Everything starts here |
