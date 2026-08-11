# Aliases
alias zconfig="code ~/.zshrc"
alias zreload="source ~/.zshrc"

# Topgrade: one-shot upgrade of everything (brew, mise, etc.)
alias upgrade="topgrade"

# Open editors
alias cu="cursor ."
alias co="code ."
alias nv="nvim ."

# AWS
alias afc='unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_PROFILE; echo "AWS credentials cleared"'
alias afp='echo "Current AWS_PROFILE: ${AWS_PROFILE:-none}"'

# Tmux
# `tm<key>` does what prefix+<key> does. Case matches the binding: tms =
# prefix+s, tmS = prefix+S. Keep in sync with ~/.tmux.conf.
#
# Anything reaching `switch-client` (tmux-sesh) must run inline, not in a
# popup: a popup is itself a client, so from a shell the switch lands on the
# popup and you get a session nested inside it. Anything reaching `attach`
# (tmux-scratch) is the reverse and needs the popup's own client.
alias tmr='tmux source-file ~/.tmux.conf && echo "Reloaded ~/.tmux.conf"'
alias tms='tmux-sesh connect'
alias s='tmux-sesh connect'
alias tmf='tmux-sesh window'
alias tmg='tmux-workspace claude'
alias tmd='tmux-workspace dev'
alias tmW='tmux-worktree-claude'
alias tmi='tmux neww $HOME/.local/bin/tmux-cht'
alias tmt='wt switch'
alias tmS='tmux display-popup -E -w 85% -h 75% "zsh $HOME/.local/bin/tmux-scratch"'
alias tmN='tmux display-popup -E -w 85% -h 80% "zsh $HOME/.local/bin/tmux-notes"'
alias tmb='tmux display-popup -E -w 60% -h 60% "zsh $HOME/.local/bin/tmux-bins"'
alias tmC="tmux split-window -h -c '#{pane_current_path}' \"zsh -lc 'mise exec -- claude'\""
alias tmV="tmux split-window -v -c '#{pane_current_path}' \"zsh -lc 'mise exec -- claude'\""
alias tmF="tmux list-windows -a -F '#{session_name}:#{window_index} #{window_name} #{pane_current_path}' | fzf --reverse | cut -d' ' -f1 | xargs tmux switch-client -t"

# Bat
# alias cat="bat"

# Directory shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# zoxide: make `z` open the interactive fzf picker (fuzzy find), like `zi`.
#   z        → fuzzy-find across the whole directory db
#   z foo    → pre-filter the db to "foo" matches, then fuzzy-find in fzf
# Use `\z foo` or `zz foo` for a direct (non-interactive) jump.
z()  { __zoxide_zi "$@"; }
zz() { __zoxide_z  "$@"; }

# fzf
alias f="fzf"
alias ff="fzf --preview 'bat --color=always --style=header,grid --line-range :500 {}'"
alias ft="fzf-tmux -p --preview 'bat --color=always --style=header,grid --line-range :500 {}'"
# export FZF_CTRL_T_COMMAND=$(ft)

alias y="yazi"

# Git
alias g="git"
alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gc="git commit"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git pull"
alias gcaa="git commit --amend -a"
alias gcaan="git commit --amend -an --no-edit"
gcm() { git checkout "$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')" }

alias ghpr="gh pr view --web 2>/dev/null || gh pr create --web"

# Terraform
alias tf="terraform"
alias tffmt="terraform fmt -recursive"

# Talos
alias t="talosctl"

# Kubernetes
alias k="kubectl"
alias kx="kubectx"
alias kns="kubens"
alias kt="kubetail"

alias kgpa="kubectl get pods --all-namespaces"
alias kg="kubectl get"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgc="kubectl get configmap"
alias kgi="kubectl get ingress"
alias kgn="kubectl get nodes"
alias kgr="kubectl get rs"
alias kd="kubectl describe"
alias kdp="kubectl describe pod"
alias kds="kubectl describe svc"
alias kdc="kubectl describe configmap"
alias kdi="kubectl describe ingress"
alias kdn="kubectl describe nodes"
alias kdr="kubectl describe rs"

alias kdel="kubectl delete"

alias grep="grep --color"
alias ll="ls -al"

alias kdrain="kubectl drain --ignore-daemonsets --delete-emptydir-data"

# Base64
alias bd="base64 --decode"
alias b="base64"

# Launchpad
alias lpad="launchpad"

# Worktrunk (git worktrees)
alias wts="wt switch --branches --remotes"
alias wtc="wt switch --create"
alias wtl="wt list"
alias wtr="wt remove"
alias wtm="wt merge"
alias wsc="wt switch --create -x claude"

# Claude Code profiles. Inline assignments beat the mise-exported env, so these
# work from any directory regardless of the repo's mise.toml.
# ccmain unsets CLAUDE_CONFIG_DIR rather than setting it: the default resolves
# the state file to ~/.claude.json, but any explicit dir moves it inside that dir.
alias ccmain='env -u ANTHROPIC_API_KEY -u CLAUDE_CONFIG_DIR claude'
alias ccwork='ANTHROPIC_API_KEY="$ANTHROPIC_WORK_API_KEY" CLAUDE_CONFIG_DIR="$HOME/.claude_work" claude'
alias ccent='env -u ANTHROPIC_API_KEY CLAUDE_CONFIG_DIR="$HOME/.claude_work" claude'

# Claude Code: yolo agent in a fresh worktrunk worktree, opened in a new
# tmux window of the current session (runs inline if not inside tmux)
# Usage: cyolo                    # auto-named worktree, interactive
#        cyolo my-feature         # named worktree
#        cyolo my-feature "..."   # named worktree + initial prompt
cyolo() {
  local name=""
  if [[ -n "$1" && "$1" != -* ]]; then
    name="$1"; shift
  fi
  [[ -z "$name" ]] && name="yolo-$(date +%m%d-%H%M%S)"

  local -a claude_args=(--dangerously-skip-permissions --remote-control "$@")

  if [[ -z "$TMUX" ]]; then
    wt switch --create "$name" -x claude -- "${claude_args[@]}"
    return
  fi

  local cmd="wt switch --create ${(q)name} -x claude --"
  local arg
  for arg in "${claude_args[@]}"; do
    cmd+=" ${(q)arg}"
  done
  tmux new-window -n "$name" -c "$PWD" "$cmd"
}

# Folder shortcuts
alias pitower="cd ~/git/github.com/swibrow/pitower"
alias dev="cd ~/git/github.com/swibrow/"


# Default applications for file types
alias -s txt=nvim
alias -s py=nvim
alias -s json=nvim

# Second brain: one long-lived pi session covering work and personal.
export SECOND_BRAIN_DIR="$HOME/dev/swibrow/second-brain"

brain() {
  local ctx=both
  case "$1" in
    work|w)        ctx=work; shift ;;
    me|personal|p) ctx=personal; shift ;;
    both|b)        ctx=both; shift ;;
  esac

  # Already multiplexed (tmux or herdr): just run in this pane.
  if [[ -n "$TMUX" || -n "$HERDR_ENV" ]]; then
    ( cd "$SECOND_BRAIN_DIR" && pi --brain "$ctx" "$@" )
    return
  fi

  # Otherwise attach to the durable session, creating it once.
  local session="brain"
  [[ "$ctx" != both ]] && session="brain-$ctx"
  if tmux has-session -t "$session" 2>/dev/null; then
    tmux attach-session -t "$session"
  else
    tmux new-session -s "$session" -c "$SECOND_BRAIN_DIR" "pi --brain $ctx"
  fi
}
