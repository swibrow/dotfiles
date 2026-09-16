# GitHub helpers. Used via the global justfile: `just -g github <recipe>`.

dev := home_directory() / 'dev'
cache := env('XDG_CACHE_HOME', home_directory() / '.cache') / 'just' / 'github-repos'

# Every repo the token can see: own, collaborator and org repos, one
# `owner/name` per line with a tab-separated `archived` marker. ~1.6k repos
# takes ~30s, hence the cache.
fetch := "gh api 'user/repos?per_page=100' --paginate --jq '.[] | .full_name + (if .archived then \"\\tarchived\" else \"\" end)'"

# Pick repos with fzf and clone them to ~/dev/<owner>/<repo> (archived hidden)
clone query='': (_clone 'no' query)

# Same as `clone`, but archived repos are listed too
clone-all query='': (_clone 'yes' query)

# Pick repos with fzf and open them in the browser (archived hidden)
open query='': (_open 'no' query)

# Same as `open`, but archived repos are listed too
open-all query='': (_open 'yes' query)

[private]
_clone archived query:
    #!/usr/bin/env zsh
    set -euo pipefail
    just --justfile '{{ module_file() }}' _pick '{{ archived }}' '{{ query }}' | while read -r repo; do
        owner="${repo%%/*}"; name="${repo#*/}"
        target="{{ dev }}/${owner:l}/$name"
        if [[ -d "$target" ]]; then
            echo "exists: $target"
        else
            gh repo clone "$repo" "$target"
        fi
    done

[private]
_open archived query:
    #!/usr/bin/env zsh
    set -euo pipefail
    just --justfile '{{ module_file() }}' _pick '{{ archived }}' '{{ query }}' | while read -r repo; do
        gh repo view --web "$repo"
    done

# fzf over the cached repo list; selected `owner/name`s go to stdout, fzf
# itself draws on the tty so callers can pipe this. A cancelled fzf yields
# nothing rather than an error.
[private]
_pick archived query:
    #!/usr/bin/env zsh
    set -euo pipefail
    [[ -s '{{ cache }}' ]] || just --justfile '{{ module_file() }}' refresh
    [[ '{{ archived }}' == yes ]] && filter=cat || filter=(grep -v $'\tarchived$')
    "${filter[@]}" < '{{ cache }}' | fzf --layout=default --multi --query '{{ query }}' --prompt 'repo> ' \
        --header 'tab: select several; run `just -g github refresh` if a repo is missing' \
        | cut -f1 || exit 0

# Refetch the cached repo list the other recipes pick from
refresh:
    #!/usr/bin/env zsh
    set -euo pipefail
    mkdir -p '{{ parent_directory(cache) }}'
    echo 'fetching repo list from GitHub...' >&2
    {{ fetch }} | sort > '{{ cache }}.tmp'
    mv '{{ cache }}.tmp' '{{ cache }}'
    echo "$(wc -l < '{{ cache }}' | tr -d ' ') repos cached in {{ cache }}" >&2
