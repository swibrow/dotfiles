# WireGuard helpers. Used via the global justfile: `just -g wireguard <recipe>`.
# Configs live in Homebrew's etc dir, one of wg-quick's search paths on macOS.

confs := env('HOMEBREW_PREFIX', '/opt/homebrew') / 'etc' / 'wireguard'
pick := "fzf --layout=default --prompt 'wireguard> ' --select-1 --exit-0"

# Bring a tunnel up, picking a config with fzf when no name is given
up name='':
    #!/usr/bin/env zsh
    set -euo pipefail
    name='{{ name }}'
    [[ -n "$name" ]] || name=$(print -l '{{ confs }}'/*.conf(N:t:r) | {{ pick }}) || { echo 'No tunnel selected'; exit 0 }
    sudo wg-quick up "$name"

# Tear a tunnel down, picking from active tunnels with fzf when no name is given
down name='':
    #!/usr/bin/env zsh
    set -euo pipefail
    name='{{ name }}'
    [[ -n "$name" ]] || name=$(print -l /var/run/wireguard/*.name(N:t:r) | {{ pick }}) || { echo 'No active tunnel selected'; exit 0 }
    sudo wg-quick down "$name"

# Show active tunnels and their peers
status:
    @sudo wg show
