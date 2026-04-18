#!/usr/bin/env zsh

selected_dir=$(cd ~/dev; fd -t d -d 2 . --color=always | fzf --ansi --highlight-line -e)
if [[ -n "$selected_dir" ]]; then
    full_path="$HOME/dev/$selected_dir"
    dir_basename=$(basename "$selected_dir")
    # Create new window
    tmux new-window -a -n "$dir_basename" -c "$full_path" -k
    # Split vertically (side by side) with same directory
    tmux split-window -h -c "$full_path"
    # Start claude in the right pane (current pane after split)
    tmux send-keys "mise exec -- claude" Enter
    # Focus the left pane
    tmux select-pane -L
else
    echo "No directory selected"
fi
