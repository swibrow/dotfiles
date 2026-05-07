#!/usr/bin/env zsh
# Claude Code hook + tmux focus hook: mark the containing tmux window.
# Usage: claude-tmux-mark <state>
#   notification — needs permission/input  -> 🔔
#   stop         — turn complete            -> 🤖
#   prompt       — user submitted, running  -> 🚀
#   clear        — strip all markers
#   focus        — strip 🔔 only (user has acknowledged the alert)

action="$1"

# Claude hooks send JSON on stdin; consume it so Claude doesn't block.
case "$action" in
  notification|stop|prompt|clear) cat >/dev/null ;;
esac

if [[ "$action" == "focus" ]]; then
  # Demote 🔔 (alert) to 🤖 (idle) — both mean "waiting on user", but
  # the alert is no longer needed since the user is now looking.
  current=$(tmux display-message -p '#W' 2>/dev/null) || exit 0
  [[ "$current" == 🔔* ]] && tmux rename-window "🤖 ${current#🔔 }"
  exit 0
fi

[[ -z "$TMUX_PANE" ]] && exit 0

case "$action" in
  notification) marker="🔔" ;;
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
