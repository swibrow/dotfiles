if [ "$(arch)" = arm64 ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="$PATH:$HOME/bin:${KREW_ROOT:-$HOME/.krew}/bin:$HOME/go/bin:$GOROOT/bin:$HOME/.local/bin:/usr/local/opt/ruby/bin"
export GOROOT="$(go env GOROOT)"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"


### Completions ###
# ZSH Completions Support
autoload -Uz compinit
compinit

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

[[ -f $HOME/.config/zsh/aliases.zsh ]] && source $HOME/.config/zsh/aliases.zsh
[[ -f $HOME/.config/zsh/functions.zsh ]] && source $HOME/.config/zsh/functions.zsh
[[ -f $HOME/.config/zsh/plugins.zsh ]] && source $HOME/.config/zsh/plugins.zsh

#### Set bind keys ####
# History substring search TODO: change to use the ^n and ^p or ^k and ^j
bindkey '^[[A' history-substring-search-up # or '\eOA'
bindkey '^[[B' history-substring-search-down # or '\eOB'
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1


# # Pligins
# source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# source $HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Chart Releases
source <(cr completion zsh)

# Talos
source <(talosctl completion zsh)

### Configurations ###
export LANG=en_US.UTF-8

# Load pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Load direnv
eval "$(direnv hook zsh)"

# AWS Vault
export AWS_VAULT_BACKEND=keychain

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

# function gam() { "/Users/samuel/bin/gam/gam" "$@" ; }
