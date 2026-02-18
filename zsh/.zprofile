if [ "$(arch)" = arm64 ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

export GOPATH="$HOME/go"

export PATH="$PATH:$HOME/.local/bin:$HOME/.local/scripts"

eval "$(mise activate zsh --shims)"
