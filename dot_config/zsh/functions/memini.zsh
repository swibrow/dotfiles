# memini memory namespace
#
# Scopes agent memory (Claude Code, opencode, pi) to the current git repo.
# Each agent's memini MCP config sends `X-Memini-Namespace: $MEMINI_NAMESPACE`,
# interpolated from the environment at launch. Recompute on every directory
# change so whichever repo you launch an agent from picks the right namespace.
#
#   in a repo with an origin remote -> <org>/<repo>  (e.g. swibrow/dotfiles)
#   in a repo without a remote      -> <toplevel dir name>
#   outside any repo                -> personal      (never an empty header)

_memini_namespace() {
  local root url ns
  root=$(git rev-parse --show-toplevel 2>/dev/null) || { print -r -- personal; return }
  url=$(git -C "$root" config --get remote.origin.url 2>/dev/null)
  if [[ -n "$url" ]]; then
    url=${url%.git}       # drop trailing .git
    url=${url##*://}      # drop scheme:// (https/ssh)
    url=${url##*@}        # drop user@
    ns=${url#*[:/]}       # drop host + first separator (scp ':' or url '/')
  else
    ns=${root:t}          # no remote: repo directory name
  fi
  print -r -- "${ns:-personal}"
}

_memini_set_namespace() { export MEMINI_NAMESPACE="$(_memini_namespace)"; }

autoload -Uz add-zsh-hook
add-zsh-hook chpwd _memini_set_namespace
_memini_set_namespace
