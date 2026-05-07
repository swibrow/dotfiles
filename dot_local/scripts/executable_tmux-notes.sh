#!/usr/bin/env zsh
# Fuzzy-find notes in the Obsidian vault, open in $EDITOR.
# Ctrl-N creates a new note in inbox/ and opens it.

vault="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/obsidian"
editor="${EDITOR:-nvim}"

[[ -d "$vault" ]] || { echo "Vault not found: $vault"; read -r; exit 1; }

cd "$vault" || exit 1

new_note() {
  local name
  printf "New note name: " >/dev/tty
  read -r name </dev/tty
  [[ -z "$name" ]] && return
  local path="inbox/${name}.md"
  mkdir -p "$(dirname "$path")"
  [[ -f "$path" ]] || printf '# %s\n\n' "$name" >"$path"
  exec "$editor" "$path"
}

if [[ "$1" == "--new" ]]; then
  new_note
fi

selected=$(
  fd --type f --extension md . 2>/dev/null \
    | fzf --reverse \
          --prompt='note> ' \
          --preview='bat --color=always --style=plain --line-range=:200 {}' \
          --preview-window=right:60% \
          --header='ctrl-n: new note in inbox/' \
          --bind="ctrl-n:become($0 --new)"
)

[[ -n "$selected" ]] && exec "$editor" "$selected"
