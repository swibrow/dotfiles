# CodeWhisperer pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/profile.pre.bash"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

function gam() { "~/bin/gam/gam" "$@" ; }

. "$HOME/.cargo/env"

# CodeWhisperer post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/codewhisperer/shell/profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/codewhisperer/shell/profile.post.bash"
