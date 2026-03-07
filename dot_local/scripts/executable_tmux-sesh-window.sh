#!/usr/bin/env zsh
# sesh picker that opens directories as new tmux windows (tabs)
# Falls back to sesh connect for existing tmux sessions

selected=$(sesh list --icons | fzf \
  --no-sort --ansi --border-label ' sesh ' --prompt '> ' \
  --header 'ctrl-a: all / ctrl-t: tmux / ctrl-x: zoxide / ctrl-d: kill' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-a:change-prompt(> )+reload(sesh list --icons)' \
  --bind 'ctrl-t:change-prompt(tmux> )+reload(sesh list --icons -t)' \
  --bind 'ctrl-x:change-prompt(zoxide> )+reload(sesh list --icons -z)' \
  --bind 'ctrl-d:execute(tmux kill-session -t {2..})+reload(sesh list --icons)')

[[ -z "$selected" ]] && exit 0

# Extract path (second field after icon)
dir=$(echo "$selected" | awk '{print $2}')
# Expand ~ to $HOME
dir="${dir/#\~/$HOME}"

if [[ -d "$dir" ]]; then
  tmux new-window -a -n "$(basename "$dir")" -c "$dir"
else
  # Existing tmux session — switch to it
  sesh connect "$selected"
fi
