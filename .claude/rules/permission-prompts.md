# Permission Prompts

A permission prompt for a routine, safe command is friction. Treat it as a signal that [settings.json](../../settings.json) is out of sync with how the project actually works — fix the root cause rather than retrying, splitting, or routing around the prompt.

When you trigger a prompt during a turn:

- If the command *should* be routine in this repo, surface a specific proposed `allow:` entry for [settings.json](../../settings.json) at end of turn. Be precise — match the command shape that actually fired, not a broader wildcard. Don't edit [settings.json](../../settings.json) yourself; let the user review.
- If the prompt fired because of a compound statement (`;`, `&&`, `|`), the fix is to split into separate Bash calls — see [bash.md](bash.md). Don't broaden the allowlist to paper over compounds.
- If the command is on the `deny:` list (e.g. `git add`), the denial is deliberate. Don't try to bypass — see [staging.md](staging.md).
- If the command is genuinely risky (sends a transaction, uses a key, hits an external service), the prompt is doing its job. Leave it alone — see [irreversible.md](irreversible.md).

If the same prompt has fired repeatedly across the session, mention the `fewer-permission-prompts` skill so the user can do a broader sweep.

## When the user says to fix a permission issue *now*

If the user signals that a permission prompt should be fixed immediately ("this should not prompt", "fix this now", "let's fix this now", or similar), **stop the task entirely**. Do not continue surveying, gathering more data, or working around the prompt — even partially. Fix the root cause first (split the compound, propose an allow entry, or correct the bash form), then wait for the user to confirm before resuming the original task. Continuing in parallel signals that the fix is secondary; it is not.
