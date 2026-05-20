# ai

Reusable [Claude Code](https://claude.ai/code) configuration — settings, rules,
skills, and slash commands — shared across Uniteum projects.

Downstream repos pull this in as a git submodule or subtree under their own
`.claude/` directory, so the paths here mirror the layout Claude Code expects.

## Layout

- [CLAUDE.md](CLAUDE.md) — authoring guidelines for this repo
- [.claude/settings.json](.claude/settings.json) — shared permissions and hook wiring
- [.claude/rules/](.claude/rules/) — markdown rules (commit style, bash usage, staging, etc.)
- [.claude/skills/](.claude/skills/) — reusable skill bundles (one directory per skill, each with a `SKILL.md`)
- [link-memory.sh](link-memory.sh) — symlink Claude Code's per-project memory dir into the repo so memory can live alongside the code
- [memory/](memory/) — destination for the memory symlink (populated by `link-memory.sh`)

## Consuming this repo

Pick one and run from the consumer repo's root:

```sh
# as a submodule
git submodule add <url> .claude

# or as a subtree
git subtree add --prefix=.claude <url> main --squash
```

Either way, the contents land at `.claude/` with no path remapping.

## Memory

`link-memory.sh` moves the per-project memory directory Claude Code creates
under `~/.claude/projects/<encoded-cwd>/memory` into `./memory` at the repo
root and leaves a symlink in its place. Run it once per checkout:

```sh
./link-memory.sh
```

After that, memory entries are tracked in the repo alongside everything else.

## Changes are breaking by default

Renaming a rule, changing hook semantics, or tightening `settings.json`
permissions propagates to every downstream repo on its next pull. Call
breaking changes out explicitly in the commit message. See
[CLAUDE.md](CLAUDE.md) for the full authoring guidelines.

## License

[MIT](LICENSE).
