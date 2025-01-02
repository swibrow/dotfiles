if [ "$(arch)" = arm64 ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
else
    export HOMEBREW_PREFIX="/usr/local"
fi
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"


# zstyle ':completion:*' menu select
export GOROOT="$(go env GOROOT)"
export PATH="$PATH:$HOME/bin:${KREW_ROOT:-$HOME/.krew}/bin:$HOME/go/bin:$GOROOT/bin:$HOME/.local/bin:/usr/local/opt/ruby/bin:/opt/homebrew/opt/ruby/bin"


export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"
export HOMEBREW_BUNDLE_LOCK=1


### Completions ###
# ZSH Completions Support
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi


#### ZSH Plugins ####
#### Antidote ####
source $HOMEBREW_PREFIX/opt/antidote/share/antidote/antidote.zsh

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.config/zsh/plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=($HOMEBREW_PREFIX/opt/antidote/share/antidote/functions/ $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

source $HOME/.config/zsh/plugins.zsh
source $HOME/.config/zsh/functions/general.zsh
# source $HOME/.config/zsh/functions/git.zsh
source $HOME/.config/zsh/functions/kubectl.zsh
source $HOME/.config/zsh/aliases.zsh

# #### Set bind keys ####
# bindkey '^E' end-of-line
# bindkey '^A' beginning-of-line
# bindkey '^P' up-line-or-history
# bindkey '^N' down-line-or-history

# # History substring search
# bindkey '^[[A' history-substring-search-up # or '\eOA'
# bindkey '^[[B' history-substring-search-down # or '\eOB'
# HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

# # Completions

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C $HOME/bin/terraform terraform

source <(cr completion zsh)
source <(talosctl completion zsh)
source <(kubectl completion zsh)
source <(helm completion zsh)
source <(k9s completion zsh)
source <(kubebuilder completion zsh)
eval "$(task --completion zsh)"
eval "$(aws-vault --completion-script-zsh)"

### Configurations ###
export LANG=en_US.UTF-8

# Load pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Load direnv
eval "$(direnv hook zsh)"

# fzf
source <(fzf --zsh)
# Catppuccin Theme
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a \
--multi"

# AWS Vault
export AWS_VAULT_BACKEND=keychain

# k9s
export K9S_CONFIG_DIR="$HOME/.config/k9s"

## Terrafrom
# tfenv
export PATH="$HOME/.tfenv/bin:$PATH"

# GPG
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Chart Release envs
export CR_OWNER=swibrow
export CR_GIT_REPO=pitower-charts
export CR_PACKAGE_PATH=.deploy
export CR_GIT_BASE_URL="https://api.github.com/"
export CR_GIT_UPLOAD_URL="https://uploads.github.com/"
export CR_SKIP_EXISTING=true


export FZF_CTRL_T_OPTS="--preview='cat --color=always --style=header,grid --line-range :500 {}'"

# Mac OSX
# defaults write -g NSWindowShouldDragOnGesture -bool true

# TODO: debug while its slow
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Cleanup
# alias gcm='git checkout $(git_default_branch)'
