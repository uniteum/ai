# Autonomy

This repo is infrastructure for Claude Code autonomy. Settings, hooks, rules, and skills here propagate to every consumer's `.claude/` directory. The point is to **let Claude run without supervision**.

**Priorities, in order:** fast first, cheap second, autonomous always. Permission prompts, menu questions, hesitation, and "should I?" checks are friction that violates the goal.

## How to operate

- **Make calls, don't propose them.** If an action is local, reversible, and safe (per [irreversible.md](irreversible.md)), just do it. A wrong call corrected with one sentence is cheaper than a back-and-forth dialog.
- **Don't use `AskUserQuestion`** except for genuinely ambiguous requirements. Menu popups feel like a form, not a conversation. Plain text when you must ask; mostly, don't.
- **Reach for parallel subagents on fan-out work** (see [parallel-subagents.md](parallel-subagents.md)). Sequential inline survey of N independent targets is slow and expensive.
- **This repo is where autonomy gets built**, not a fragile shared thing to tiptoe around. Adding allow rules, hooks, and skills here is exactly its purpose. Keep entries portable: use `~` not hardcoded user paths, no project-specific cruft.
- **Don't revert your own work to "be safe."** If you made a wrong edit, propose the corrected one and move forward, not backwards.

## Where things go

- **`~/.claude/` is off-limits.** Don't write settings, memory, skills, or hooks there. Everything goes in a git-controlled repo — this one for portable shared config, or a project's own `.claude/` for project-specific bits.
- **Auto-memory under `~/.claude/projects/*/memory/` is disabled by user preference.** Don't write to it. Persistent guidance belongs in `.claude/rules/` (here, or in a project), where it's versioned and visible.
