---
name: branch-status
description: Summarize the current branch's state versus the base branch — commits, file changes, working tree, and ahead/behind — so the user can quickly resume work or decide if a branch is ready for review. Use when the user asks "where am I", "what's on this branch", "is this ready to push", or returns to a branch after a break.
---

# branch-status

Produce a fast, accurate snapshot of the current branch. The goal is for the user to understand, in one screen, what changed and what's left to do before they take the next action (commit, push, open a PR, or hand off).

## What to gather

Run these in parallel as a single Bash batch:

- `git rev-parse --abbrev-ref HEAD` — current branch name
- `git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'` — base branch (fall back to `main` if it fails)
- `git status --short` — working tree (do NOT use `-uall`)
- `git log --oneline @{u}..HEAD 2>/dev/null` and `git log --oneline HEAD..@{u} 2>/dev/null` — ahead/behind upstream (skip silently if no upstream)
- `git log --oneline <base>..HEAD` — commits on this branch
- `git diff --stat <base>...HEAD` — net file changes vs base
- `git diff --stat` — unstaged
- `git diff --cached --stat` — staged

Once `<base>` is known from the second command, substitute it into the later ones.

## How to report

Keep the report to roughly 10–20 lines. Use this shape:

```
Branch: <name> (vs <base>)
Upstream: <ahead>/<behind> or "no upstream"
Working tree: <clean | N staged, M unstaged, K untracked>

Commits on branch (<n>):
  <sha> <subject>
  ...

Files changed vs base (<n>):
  <path>  +<add> -<del>
  ...

Status: <one-line judgment — e.g. "clean, ready to push" | "uncommitted work in X" | "diverged from upstream — rebase needed">
```

If the branch is the base branch itself (no commits ahead), say so and stop — there's nothing to summarize.

## Judgment line

The final "Status:" line is the most valuable output. Base it on what you actually saw:

- **Clean and pushed**: working tree clean, 0 ahead, 0 behind upstream → "up to date with upstream"
- **Ready to push**: working tree clean, commits ahead of upstream, none behind → "ready to push"
- **WIP**: uncommitted changes present → name the dirty files and say what looks incomplete
- **Diverged**: behind upstream with local commits → flag that a rebase/merge is needed before push
- **Possibly ready for PR**: clean, commits ahead of base, in sync with upstream → "looks ready for PR" (do not open the PR — the user will)

Do not invent a status if signals conflict; describe what you see and ask what they want to do.

## Out of scope

- Do not run tests, builds, or linters — this skill is read-only and fast.
- Do not stage, commit, push, or rebase — only report.
- Do not generate a PR title or body — that's a separate concern.
