#!/usr/bin/env zsh
# Claude Code hook: mark the containing tmux window with agent state.
# Usage: claude-tmux-mark <state>
#   notification — needs permission/input  -> 🔔
#   stop         — turn complete            -> 🤖
#   prompt       — user submitted, running  -> 🚀
#   clear        — strip all markers

# Claude hooks send JSON on stdin; capture it so Claude doesn't block.
input=$(cat)

[[ -z "$TMUX_PANE" ]] && exit 0

case "$1" in
  notification)
    # Notification fires for both permission requests and idle reminders.
    # Only mark on permission — idle would overwrite 🤖 unnecessarily.
    msg=$(printf '%s' "$input" | jq -r '.message // ""' 2>/dev/null)
    [[ "$msg" == *permission* ]] || exit 0
    marker="🔔"
    ;;
  stop)         marker="🤖" ;;
  prompt)       marker="🚀" ;;
  clear)        marker="" ;;
  *)            exit 0 ;;
esac

current=$(tmux display-message -p -t "$TMUX_PANE" '#W' 2>/dev/null) || exit 0

# Strip any leading markers (own + leaked from other tools) repeatedly.
stripped=$current
while true; do
  new=${stripped#(🤖|🔔|🚀|⚙|⏳|⌛|✅) }
  [[ "$new" == "$stripped" ]] && break
  stripped=$new
done

if [[ -n "$marker" ]]; then
  tmux rename-window -t "$TMUX_PANE" "${marker} ${stripped}"
else
  tmux rename-window -t "$TMUX_PANE" "${stripped}"
fi
