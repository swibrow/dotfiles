#!/usr/bin/env zsh

# Start tmux: attach to "main" session if it has no clients,
# otherwise show sesh picker to connect to an existing or new session.

if tmux has-session -t main 2>/dev/null && [ -n "$(tmux list-clients -t main)" ]; then
  # main is already attached — show sesh picker
  selected=$(sesh list --icons | fzf \
    --no-sort --ansi --border-label ' sesh ' --prompt '> ' \
    --header 'ctrl-a: all / ctrl-t: tmux / ctrl-x: zoxide / ctrl-d: kill' \
    --bind 'tab:down,btab:up' \
    --bind 'ctrl-a:change-prompt(> )+reload(sesh list --icons)' \
    --bind 'ctrl-t:change-prompt(tmux> )+reload(sesh list --icons -t)' \
    --bind 'ctrl-x:change-prompt(zoxide> )+reload(sesh list --icons -z)' \
    --bind 'ctrl-d:execute(tmux kill-session -t {2..})+reload(sesh list --icons)')

  [[ -z "$selected" ]] && exit 0

  sesh connect "$selected"
else
  tmux new-session -A -s main
fi
