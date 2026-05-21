# Git Submodules

Before committing any change inside a git submodule, make sure HEAD points at a real branch — not a detached commit. Orphaned commits require cherry-picks to recover. Whichever branch the submodule is already on is fine; what matters is that HEAD isn't floating.

The flow:

1. `cd` into the submodule directory.
2. `git status` — if HEAD is detached, check out a real branch first (typically `main`, or whatever branch the submodule was meant to be on).
3. Make the change and commit on that branch.
4. `cd` back to the parent repo. Its working tree now shows the submodule pointer as modified; that bump is its own commit, subject to the [staging.md](staging.md) rule like everything else.
