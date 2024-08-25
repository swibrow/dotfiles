# Aliases
alias zconfig="code ~/.zshrc"
alias zreload="source ~/.zshrc"

# Git
alias g="git"
# alias gcm="git checkout $(git_main_branch)"

alias gst="git status"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

alias gcaa="git commit --amend -a --no-edit"

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

alias kd="kubectl drain --ignore-daemonsets --delete-emptydir-data"



# Base64
alias bd="base64 --decode"
alias b="base64"

alias tg="task --global"

# Folder shortcuts
alias pitower="cd ~/git/github.com/swibrow/pitower"
alias dev="cd ~/git/github.com/swibrow/"


# Default applications for file types
alias -s txt=nvim
alias -s py=nvim
alias -s json=nvim