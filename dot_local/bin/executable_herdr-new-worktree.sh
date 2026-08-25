#!/usr/bin/env zsh
# New worktree as a sibling of the repo (<repo>.<branch-slug>) instead of
# herdr's built-in ~/.herdr/worktrees/<repo>/<branch-slug>; worktrees.directory
# is a single fixed root and cannot express a per-repo sibling path.
source "$HOME/.zprofile"

current=$(herdr pane current)
cwd=$(printf '%s' "$current" | jq -r '.result.pane.foreground_cwd // .result.pane.cwd')

if ! common=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null); then
  print -u2 -- "not inside a git work tree: $cwd"
  read -rs -k1
  exit 1
fi
# common dir is the *main* repo's .git even from a linked worktree, so nested
# worktrees stay siblings of the repo rather than chaining <repo>.a.b
repo="${common:h}"

branch=""
# vared gives the popup full ZLE line editing; read has none.
vared -p 'new worktree branch: ' branch
[[ -n "$branch" ]] || exit 0

path="${repo}.${branch//\//-}"

if ! out=$(herdr worktree create --cwd "$cwd" --branch "$branch" --path "$path" --focus 2>&1); then
  print -u2 -- "$out"
  read -rs -k1
  exit 1
fi
