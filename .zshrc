if [ "$(arch)" = arm64 ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH=$HOME/bin:$PATH
export PATH=$HOME/go/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Krew
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
export GOPATH=$HOME/go
export GOROOT=/usr/local/opt/go/libexec
export PATH=$GOPATH/bin:$PATH
export PATH=$PATH:$GOROOT/bin
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="simple"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# # Pyenv config
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

plugins=(
  ansible
  aws
  brew
  docker
  dotenv
  encode64
  fluxcd
  git
  golang
  helm
  kubectl
  kubectx
  kubetail
  kube-ps1
  macos
  nmap
  otp
  pass
  pyenv
  terraform
  zsh-aws-vault
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
  zsh-history-substring-search
)

# # https://github.com/zsh-users/zsh-completions
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

eval "$(direnv hook zsh)"

# User configuration

### Completions ###
# Chart Releases
source <(cr completion zsh)
source <(talosctl completion zsh)

# # Kube PS1
NEWLINE=$'\n\$ '
PS1='$(kube_ps1)'$PS1$NEWLINE

# AWS Vault
export AWS_VAULT_BACKEND=keychain

# tfenv
export PATH="$HOME/.tfenv/bin:$PATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Aliases
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias new-shell="exec $SHELL"

alias tffmt="terraform fmt -recursive"



export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# Talos
alias t="talosctl"

# Kubenetes
alias k="kubectl"
alias kx="kubectx"
alias kns="kubens"
alias kt="kubetail"

alias kd="kubectl drain --ignore-daemonsets --delete-emptydir-data"

kpodbynode() {
  kubectl get pods -A -owide --field-selector=spec.nodeName="${1}",status.phase=Running
}
kpodbylabel() {
  kubectl get pods -A -owide --selector="${1}"
}

kremovefinalizers() {
  if [ -z "${1}" ] || [ -z "${2}" ]; then
    echo "Please provide a resource type and name."
    return 1
  fi
  kubectl patch "${1} ${2}" -p '{"metadata":{"finalizers":[]}}' --type=merge
}

# Terraform
alias tf="terraform"

# Base64
alias bd="base64 --decode"
alias b="base64"

alias tg="task --global"
# # Ip Forwarding
# alias ipf="sudo sysctl -w net.ipv4.ip_forward=1"


# Functions
_a() {
    # kubectl config use-context "${1}"
    unset AWS_VAULT
    aws-vault exec "${1}"

}

pg_up() {
  docker kill postgres || true
  docker run \
    --rm \
    --name postgres \
    -p 5432:5432 \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=postgres \
    -d \
    postgres:14.3
}

eks_config() {
  aws eks update-kubeconfig --name="${1}" --alias "${2}"
}

function cloner {
   curl -H "Authorization: token $1" -s "https://api.github.com/orgs/$2/repos?per_page=100&page=${3:-"1"}" \
       | sed -n '/"ssh_url"/s/.*ssh_url": "\([^"]*\).*/\1/p' \
       | sort -u \
       | xargs -n1 git clone;
}

# Chart Release envs
export CR_OWNER=swibrow
export CR_GIT_REPO=pitower-charts
export CR_PACKAGE_PATH=.deploy
export CR_GIT_BASE_URL="https://api.github.com/"
export CR_GIT_UPLOAD_URL="https://uploads.github.com/"
export CR_SKIP_EXISTING=true

function gam() { "/Users/samuel/bin/gam/gam" "$@" ; }
export PATH="/usr/local/opt/ruby/bin:$PATH"
