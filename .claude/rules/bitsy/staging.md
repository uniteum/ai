---
paths:
  - "**"
---

# Git Staging

Do not stage files. The user commits from their editor, which only picks up staged files — if you stage some files and leave others unstaged, the resulting commit is incomplete.

- Don't run `git add`, `git -C <dir> add`, `git rm --cached`, `git mv`, or `git apply --cached`/`--index`. These are denied in [settings.json](../../settings.json); don't try to work around the denial.
- Don't run `git commit -a` either — it stages tracked changes as a side effect.
- Leave the working tree dirty. The user will stage and commit themselves.
- See [commit-messages.md](commit-messages.md) for how to hand off a suggested commit message at the end of your turn.
