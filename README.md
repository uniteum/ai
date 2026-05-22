# ai

Reusable [Claude Code](https://claude.ai/code) configuration — settings, rules,
skills, and slash commands — shared across Uniteum projects.

Downstream repos add this as a git submodule, then symlink the rulesets they
want into their own `.claude/rules/`.

## Layout

- [CLAUDE.md](CLAUDE.md) — authoring guidelines for this repo
- [RULESETS.md](RULESETS.md) — catalog of available rulesets
- [.claude/settings.json](.claude/settings.json) — shared permissions and hook wiring
- [.claude/rules/](.claude/rules/) — markdown rules, grouped into rulesets
- [.claude/skills/](.claude/skills/) — reusable skill bundles (one directory per skill, each with a `SKILL.md`)
- [.claude/commands/](.claude/commands/) — reusable slash commands (one `<name>.md` per command, invoked as `/<name>`)
- [link-rulesets.sh](link-rulesets.sh) — symlink selected rulesets into a consumer's `.claude/rules/`
- [link-memory.sh](link-memory.sh) — symlink Claude Code's per-project memory dir into the repo so memory can live alongside the code
- [memory/](memory/) — destination for the memory symlink (populated by `link-memory.sh`)

## Consuming this repo

From the consumer repo's root, add this repo as a submodule and link the
rulesets you want (see [RULESETS.md](RULESETS.md) for the menu):

```sh
git submodule add <url> .claude/vendor/ai
.claude/vendor/ai/link-rulesets.sh autonomy git
```

`link-rulesets.sh` creates symlinks under `.claude/rules/` and records the
selection in `.claude/rules/.rulesets`. Commit the submodule, the symlinks, and
the sentinel. Re-run the script with a different list to change the selection;
it adds and removes only the symlinks it manages.

Fresh clones of the consumer repo need the submodule populated:

```sh
git clone --recurse-submodules <consumer-url>
# or, in an existing clone:
git submodule update --init
```

This mechanism covers `.claude/rules/` only — consuming `settings.json`, skills,
or commands isn't automated yet.

## Memory

`link-memory.sh` moves the per-project memory directory Claude Code creates
under `~/.claude/projects/<encoded-cwd>/memory` into `./memory` at the repo
root and leaves a symlink in its place. Run it once per checkout:

```sh
./link-memory.sh
```

After that, memory entries are tracked in the repo alongside everything else. The symlink handles placement transparently, so no rule in `.claude/rules/` is needed to govern *where* memory files go — don't add one.

## Changes are breaking by default

Renaming a rule, changing hook semantics, or tightening `settings.json`
permissions propagates to every downstream repo on its next pull. Call
breaking changes out explicitly in the commit message. See
[CLAUDE.md](CLAUDE.md) for the full authoring guidelines.

## License

[MIT](LICENSE).
