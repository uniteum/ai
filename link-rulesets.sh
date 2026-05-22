#!/usr/bin/env bash
#
# link-rulesets.sh — symlink selected rulesets from this repo into a consumer
# repo's .claude/rules/.
#
# Prerequisite: this repo is already a submodule of the consumer repo, e.g.
#
#   git submodule add <url> .claude/vendor/ai
#
# Then, from the consumer repo root:
#
#   .claude/vendor/ai/link-rulesets.sh autonomy git
#
# Re-run with a different list to change the selection; symlinks are added and
# removed to match. Only symlinks this script manages (tracked in the sentinel
# .claude/rules/.rulesets) are removed — your own files are never touched.
#
#   --list   print available rulesets and exit

set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
src_rules="$script_dir/.claude/rules"
dest_rules="$PWD/.claude/rules"
sentinel_name=".rulesets"

die() { printf 'error: %s\n' "$1" >&2; exit 1; }

usage() {
  printf 'Usage: %s <ruleset>...\n   or: %s --list\n' \
    "$(basename "${BASH_SOURCE[0]}")" "$(basename "${BASH_SOURCE[0]}")"
}

list_available() {
  local d
  for d in "$src_rules"/*/; do
    [ -d "$d" ] && printf '%s\n' "$(basename "$d")"
  done
}

# Relative path from $1 (base dir) to $2 (target); both must be absolute.
relpath() {
  local base=$1 target=$2 common back=""
  common=$base
  while [ "${target#"$common"/}" = "$target" ] && [ "$common" != "/" ]; do
    common=$(dirname "$common")
    back="../$back"
  done
  if [ "$common" = "/" ]; then
    printf '%s\n' "$back${target#/}"
  else
    printf '%s\n' "$back${target#"$common"/}"
  fi
}

[ -d "$src_rules" ] || die "ruleset source not found at $src_rules (is the submodule checked out?)"

requested=()
while [ $# -gt 0 ]; do
  case "$1" in
    --list) list_available; exit 0 ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown flag: $1" ;;
    *) requested+=("$1") ;;
  esac
  shift
done

# No rulesets given: show what's available and what's currently linked.
if [ ${#requested[@]} -eq 0 ]; then
  printf 'Available rulesets:\n'
  list_available | sed 's/^/  /'
  if [ -f "$dest_rules/$sentinel_name" ]; then
    printf 'Currently linked:\n'
    sed 's/^/  /' "$dest_rules/$sentinel_name"
  fi
  usage
  exit 0
fi

[ -d "$PWD/.claude" ] || die "no .claude/ here — run from your consumer repo root"

mkdir -p "$dest_rules"
dest_rules=$(cd "$dest_rules" && pwd)
sentinel="$dest_rules/$sentinel_name"

# Validate everything before making any change: each ruleset must exist in the
# source, and its destination must not be a real file/dir we'd clobber.
for r in "${requested[@]}"; do
  [ -d "$src_rules/$r" ] || die "unknown ruleset: $r (try --list)"
  link="$dest_rules/$r"
  if [ -e "$link" ] && [ ! -L "$link" ]; then
    die "$link exists and is not a symlink; refusing to overwrite"
  fi
done

# Remove symlinks for previously-managed rulesets no longer requested.
if [ -f "$sentinel" ]; then
  while IFS= read -r old || [ -n "$old" ]; do
    [ -n "$old" ] || continue
    case " ${requested[*]} " in *" $old "*) continue ;; esac
    link="$dest_rules/$old"
    if [ -L "$link" ]; then
      rm "$link"
      printf 'removed  %s\n' "$old"
    fi
  done < "$sentinel"
fi

# Create or repoint symlinks for the requested rulesets.
for r in "${requested[@]}"; do
  link="$dest_rules/$r"
  target=$(relpath "$dest_rules" "$src_rules/$r")
  ln -sfn "$target" "$link"
  printf 'linked   %s -> %s\n' "$r" "$target"
done

printf '%s\n' "${requested[@]}" > "$sentinel"
