# Parallel Subagents

For survey, search, or audit work across multiple independent targets (repos, services, endpoints, packages, files in unrelated trees), default to launching **parallel `Explore` or `general-purpose` subagents** — one per target, in a single message — rather than handling inline with sequential Bash/grep/Read.

**Why:** Supports [autonomy.md](autonomy.md): fast first, cheap second. Sequential inline surveys are slow (no concurrency) and expensive — every intermediate result lands in the main context, growing the prompt that gets re-sent each turn.

## How to apply

- **Threshold:** ≥5 independent targets, each investigable without depending on the others' results.
- **Pattern:** All Agent calls in a single assistant message so they run concurrently. Announce briefly ("Launching N agents in parallel across …") so it's visible.
- **Agent type:** `Explore` for read-only survey/search; `general-purpose` if the agent also needs to synthesize or do multi-step work.
- **Prompt shape:** Each subagent prompt is self-contained — state the goal, the bar for what's relevant, the output format (typically a short structured report, cap the length).
- **Synthesize in main thread.** Subagents survey; you judge.
- **Skip parallel** for: single-target tasks, work where each step informs the next, fan-out of 2-3 where inline is comparable.
