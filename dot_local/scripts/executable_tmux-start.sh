#!/usr/bin/env bash

# Start tmux: attach to "main" session if it has no clients,
# otherwise create a new ephemeral session that auto-destroys on detach.

if tmux has-session -t main 2>/dev/null && [ -n "$(tmux list-clients -t main)" ]; then
  tmux new-session \; set-option destroy-unattached on \; set-option detach-on-destroy on
else
  tmux new-session -A -s main
fi
