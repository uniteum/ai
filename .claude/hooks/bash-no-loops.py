#!/usr/bin/env python3
"""PreToolUse hook: reject Bash commands wrapping `for`/`while`/`if` constructs.

Per .claude/rules/bash.md, shell control structures inside a single Bash
invocation should be split into separate parallel Bash calls — that way each
command is matched individually by permission rules and runs concurrently.
"""
import json
import re
import sys

PATTERN = re.compile(
    r"(?:^|[;&|\n]|\bdo\b|\bthen\b|\belse\b)\s*(for|while|if)\s"
)


def main() -> int:
    try:
        data = json.load(sys.stdin)
    except json.JSONDecodeError:
        return 0

    if data.get("tool_name") != "Bash":
        return 0

    command = data.get("tool_input", {}).get("command", "")
    match = PATTERN.search(command)
    if not match:
        return 0

    keyword = match.group(1)
    print(
        f"Blocked: Bash command contains a shell `{keyword}` construct.\n"
        "Per .claude/rules/bash.md, split into separate parallel Bash calls — "
        "one per iteration — so each can match permission rules individually "
        "and run concurrently. If a genuine loop is required (dynamic input, "
        "real dependency), put it in a script file and execute that.",
        file=sys.stderr,
    )
    return 2


if __name__ == "__main__":
    sys.exit(main())
