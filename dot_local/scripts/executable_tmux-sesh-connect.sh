#!/usr/bin/env zsh
# sesh picker that opens selected session/directory in a new tmux session
# Intended to be run from a new Ghostty window (outside tmux)

selected=$(sesh list --icons | fzf \
  --ansi --border-label ' sesh ' --prompt '> ' \
  --header 'ctrl-a: all / ctrl-t: tmux / ctrl-x: zoxide / ctrl-d: kill' \
  --bind 'tab:down,btab:up' \
  --bind 'ctrl-a:change-prompt(> )+reload(sesh list --icons)' \
  --bind 'ctrl-t:change-prompt(tmux> )+reload(sesh list --icons -t)' \
  --bind 'ctrl-x:change-prompt(zoxide> )+reload(sesh list --icons -z)' \
  --bind 'ctrl-d:execute(tmux kill-session -t {2..})+reload(sesh list --icons)' \
  --preview-window 'right:55%' \
  --preview 'sesh preview {2..}')

[[ -z "$selected" ]] && exit 0

sesh connect "$selected"
