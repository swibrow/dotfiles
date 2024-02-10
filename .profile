export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

function gam() { "~/bin/gam/gam" "$@" ; }

. "$HOME/.cargo/env"

