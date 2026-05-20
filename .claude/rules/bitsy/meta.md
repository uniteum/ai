---
paths:
  - "**"
---

# Updating Instructions

When adding or changing instructions, put them in the most specific location that applies:

1. `.claude/rules/` files — for operational rules filtered by path
2. Subdirectory `CLAUDE.md` — for scope-specific rules
3. Root `CLAUDE.md` — only for rules that apply across the whole repo

Prefer rules files over CLAUDE.md when the rule can be scoped by file path pattern.
