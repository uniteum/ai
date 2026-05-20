---
description: Generate a commit message based on current git changes
---

Generate a git commit message for the current staged/unstaged changes.

1. Run `git status` to see what files are modified.
2. Run `git diff` on the modified files to see the actual changes.
3. Run `git log -5 --oneline` to match the repository's existing style.
4. Produce a message that:
   - Uses imperative mood ("Add" not "Added").
   - Has a 50–72 character subject line.
   - Focuses on the *why* rather than the *what*.
   - Includes a brief body only when the *why* isn't obvious from the diff.
5. Present the message in a code block for the user to copy.

Do not run `git commit` yourself, and do not stage files. See [commit-messages.md](../rules/commit-messages.md) and [staging.md](../rules/staging.md) for the broader policy.
