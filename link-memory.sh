#!/usr/bin/env bash
# Symlink Claude Code's per-project memory directory into the current git repo.
#
# Claude Code stores memory at ~/.claude/projects/<encoded-cwd>/memory, where
# <encoded-cwd> is the absolute path with '/' replaced by '-'. This script
# moves that directory into ./memory at the repo root and leaves a symlink in
# its place, so memory lives alongside the code and can be version-controlled.

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
repo_memory="$repo_root/memory"

encoded="${repo_root//\//-}"
default_memory="$HOME/.claude/projects/${encoded}/memory"

mkdir -p "$repo_memory"
mkdir -p "$(dirname "$default_memory")"

if [[ -L "$default_memory" ]]; then
    current="$(readlink "$default_memory")"
    if [[ "$current" == "$repo_memory" ]]; then
        echo "Already linked: $default_memory -> $repo_memory"
        exit 0
    fi
    echo "Replacing existing symlink $default_memory (was -> $current)"
    rm "$default_memory"
elif [[ -d "$default_memory" ]]; then
    echo "Migrating existing memory from $default_memory into $repo_memory"
    shopt -s dotglob nullglob
    for entry in "$default_memory"/*; do
        name="$(basename "$entry")"
        if [[ -e "$repo_memory/$name" ]]; then
            echo "  skip: $name (already exists in $repo_memory)" >&2
        else
            mv "$entry" "$repo_memory/"
        fi
    done
    shopt -u dotglob nullglob
    rmdir "$default_memory" 2>/dev/null || {
        echo "Could not remove $default_memory (not empty?). Aborting." >&2
        exit 1
    }
elif [[ -e "$default_memory" ]]; then
    echo "Unexpected non-directory at $default_memory. Aborting." >&2
    exit 1
fi

ln -s "$repo_memory" "$default_memory"
echo "Linked $default_memory -> $repo_memory"
