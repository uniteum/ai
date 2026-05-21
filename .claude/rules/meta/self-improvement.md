# Self-Improvement

When the same friction recurs across conversations, the fix is a new rule, not better memory. Persistent guidance lives in `.claude/rules/` where it's versioned, visible, and propagates to every consumer — see [autonomy.md](../autonomy/autonomy.md).

## Symptoms to notice

- The user has to repeat or rephrase a request.
- The user corrects an assumption or approach you took.
- A task takes multiple back-and-forth rounds when it should have been one.
- The user overrides a tool call, rejects a permission prompt, or denies an action you re-attempted.
- Output is at the wrong level of detail for what they wanted.

## How to respond

When you spot recurring friction, propose a rule that would have prevented it:

1. Name the behavior — what to do, when it applies.
2. State the **why** — usually the friction you observed, so future-you can judge edge cases instead of following blindly.
3. Decide where it belongs per [meta.md](meta.md).

Hand the proposed rule to the user for review. Don't add rules silently; they propagate on the next pull.

If the friction is a recurring permission prompt, that's usually a [settings.json](../../settings.json) issue, not a rule issue — see [permission-prompts.md](../autonomy/permission-prompts.md).

## What not to record

- One-off misunderstandings that were immediately clarified.
- Friction from external factors (slow network, tool bugs) rather than interaction patterns.
- Anything already covered by an existing rule.
