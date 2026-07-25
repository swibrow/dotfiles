# Aliases
alias zconfig="code ~/.zshrc"
alias zreload="exec zsh"

# Topgrade: one-shot upgrade of everything (brew, mise, etc.)
alias upgrade="topgrade"
alias tm='task-master'

# Open editors
alias cu="cursor ."
alias co="code ."
alias nv="nvim ."

# Tmux
alias s='tmux send-keys C-Space s'

# Directory shortcuts
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# fzf
alias f="fzf"
alias ff="fzf --preview 'bat --color=always --style=header,grid --line-range :500 {}'"
alias ft="fzf-tmux -p --preview 'bat --color=always --style=header,grid --line-range :500 {}'"

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
alias kgp="kg p"
alias kgs="kg s"
alias kgc="kg c"
alias kgi="kg i"
alias kgn="kg n"
alias kgr="kg r"
alias kdp="kd p"
alias kds="kd s"
alias kdc="kd c"
alias kdi="kd i"
alias kdn="kd n"
alias kdr="kd r"

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

# Folder shortcuts
alias pitower="cd ~/git/github.com/swibrow/pitower"
alias dev="cd ~/git/github.com/swibrow/"


# Default applications for file types
alias -s txt=nvim
alias -s py=nvim
alias -s json=nvim
