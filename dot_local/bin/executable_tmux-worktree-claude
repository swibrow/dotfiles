#!/usr/bin/env zsh

# Pick a repo under ~/dev, create a git worktree for a new branch via worktrunk,
# and open a new tmux window in that worktree running claude.
# Works from any session/window regardless of the current pane's repo.

selected_dir=$(cd ~/dev; fd -t d -d 2 . --color=always | fzf --ansi --highlight-line -e --prompt="repo> ")
[[ -z "$selected_dir" ]] && { echo "No repo selected"; exit 0 }

repo_path="$HOME/dev/$selected_dir"

read "branch?new worktree branch: "
[[ -z "$branch" ]] && { echo "No branch given"; exit 0 }

# wt creates the worktree (off the repo at -C, not the current pane), then -x
# opens a new window in the worktree path running claude. {{ branch }} and
# {{ worktree_path }} are worktrunk template vars (same as the prefix+T binding).
wt -C "$repo_path" switch --create "$branch" --no-cd \
    -x 'tmux new-window -n {{ branch | sanitize }} -c {{ worktree_path }} "zsh -lc \"mise exec -- claude\""'
