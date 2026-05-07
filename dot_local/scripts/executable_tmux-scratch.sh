#!/usr/bin/env zsh
# Persistent scratch tmux session, opened in a popup.
# State survives popup close — reopen returns to the same shell/cwd.

session="scratch"

if ! tmux has-session -t "$session" 2>/dev/null; then
  tmux new-session -d -s "$session" -c "$HOME"
fi

exec tmux attach -t "$session"
