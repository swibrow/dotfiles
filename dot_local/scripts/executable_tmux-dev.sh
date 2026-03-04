#!/usr/bin/env zsh

selected_dir=$(cd ~/dev; fd -t d -d 2 . --color=always | fzf --ansi --highlight-line -e)
if [[ -n "$selected_dir" ]]; then
    full_path="$HOME/dev/$selected_dir"
    dir_basename=$(basename "$selected_dir")
    # Create new window
    tmux new-window -a -n "$dir_basename" -c "$full_path" -k
    # Split horizontally (left/right)
    tmux split-window -h -c "$full_path"
    # Split right pane vertically (top/bottom)
    tmux split-window -v -c "$full_path"
    # Start nvim with file browser
    tmux send-keys -t 0 "nvim ." Enter
    # Start claude in top right pane
    tmux send-keys -t 1 "claude" Enter
    # Focus the editor (left pane)
    tmux select-pane -t 0
else
    echo "No directory selected"
fi
