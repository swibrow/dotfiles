#!/usr/bin/env zsh

selected_dir=$(cd ~/dev; fd -t d -d 2 . --color=always | fzf --ansi --highlight-line -e)
if [[ -n "$selected_dir" ]]; then
    dir_basename=$(basename "$selected_dir")
    tmux new-window -a -n "${dir_basename:0:6}" -c "$HOME/dev/$selected_dir" -k
else
    echo "No directory selected"
fi
