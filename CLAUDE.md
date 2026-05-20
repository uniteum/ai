# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This repo holds **reusable Claude Code configuration** — settings, hooks, rules, skills, and slash commands — that downstream projects pull in as a git submodule or subtree under their `.claude/` directory. Treat every file as something that may be live in many downstream repos: a careless change here propagates.

## Layout

Content is grouped by Claude Code's own conventions so that a downstream `.claude/` can pull from this repo with paths unchanged:

- `settings.json` (and any `hooks/` scripts it references) — permissions, env, hook wiring
- `rules/` — markdown rules and instructions (commit style, review checklists, tone, etc.)
- `skills/<name>/SKILL.md` — reusable skill bundles
- `commands/*.md` — reusable slash commands

When adding a new artifact, mirror the directory name Claude Code expects so consumers don't have to remap paths.

## Authoring guidelines

- **Keep it generic.** Anything project-specific (a particular repo's build command, a stack-specific lint rule) belongs in that project's own `.claude/`, not here. If you're tempted to add it, ask whether at least two unrelated projects would benefit.
- **Hooks must be portable.** Don't hardcode absolute paths, usernames, or assume a specific working directory; downstream repos will invoke these from their own roots.
- **Changes are breaking by default.** Renaming a rule file, changing a hook's exit semantics, or tightening permissions in `settings.json` can break every consumer on their next pull. Note breaking changes clearly in the commit message.
- **No invented documentation.** Don't add architecture, command, or workflow docs to CLAUDE.md or READMEs describing things that don't exist yet — wait until the artifact is real.

## Consumers

Downstream consumers are not enumerated here — they pull this repo in on their own terms. Before changing a shared file, consider that some unknown set of repos will receive the change on their next update, and call breaking changes out explicitly in the commit message.
