# Brewfile

All packages managed by Homebrew, split across two files at the root of the
chezmoi source dir:

- `homebrew/Brewfile` — cross-platform CLI tools, installed on both the `osx`
  and `linux-dev` profiles.
- `homebrew/Brewfile.macos` — GUI casks and the handful of macOS-only formulas,
  installed only on the `osx` profile.

`~/.config/homebrew/Brewfile` and `Brewfile.macos` are **symlinks** back into
the source dir (`dot_config/homebrew/symlink_Brewfile.tmpl`), and
`HOMEBREW_BUNDLE_FILE` points at the first one. Every `brew bundle` subcommand
therefore reads and writes the repo directly — nothing to copy back, and no
edits for `chezmoi apply` to silently revert.

## Staying in sync

`brew install` / `brew uninstall` are wrapped in zsh
(`dot_config/zsh/functions/general.zsh`) and mirrored into the right Brewfile by
[`brewfile-sync`](scripts.md), so a later `brew bundle` cannot
resurrect something you removed. Work-tap entries are routed to the private
layer, casks to `Brewfile.macos`, everything else to `Brewfile`. After
installing from a script rather than an interactive shell, run
`brewfile-sync add <pkg>` by hand.

To rebuild a Brewfile from scratch instead:

```bash
brew bundle dump --force --no-vscode
```

!!! warning
    Always use `--no-vscode` to exclude VS Code extensions. A dump also flattens
    the three-way split — it re-adds the work tap and its formulae, and puts
    casks in the main file. Move those back before committing.

Both Brewfiles are auto-installed during `chezmoi apply` via a hash-tracked run
script, which passes `--no-upgrade` so an apply never upgrades packages behind
your back.

## Categories

### Shell & Terminal

| Package | Description |
|---------|-------------|
| `zsh` | Shell |
| `zsh-autosuggestions` | Fish-like suggestions |
| `zsh-fast-syntax-highlighting` | Syntax highlighting |
| `starship` | Prompt |
| `fzf` | Fuzzy finder |
| `zoxide` | Smart cd |
| `atuin` | Shell history |
| `carapace` | Completion bridge |
| `bat` | Cat with syntax highlighting |
| `eza` | Modern ls |
| `ripgrep` | Fast grep |
| `fd` | Fast find |
| `jq` / `yq` | JSON/YAML processing |
| `glow` | Markdown renderer |
| `tmux` | Terminal multiplexer |

### Editors

| Package | Description |
|---------|-------------|
| `neovim` | Editor |
| `vim` | Fallback editor |

### Git & Version Control

| Package | Description |
|---------|-------------|
| `git` | Version control |
| `gh` | GitHub CLI |
| `gnupg` | GPG signing |
| `pre-commit` | Git hooks |
| `gum` | Interactive CLI (used by git wipeout) |

### Kubernetes

| Package | Description |
|---------|-------------|
| `kubectl` | Kubernetes CLI |
| `kubectx` | Context switching |
| `kubens` | Namespace switching |
| `kubetail` | Log tailing |
| `helm` | Package manager |
| `k9s` | Terminal UI |
| `kustomize` | Manifest customization |
| `kubeconform` | Manifest validation |
| `kube-capacity` | Resource usage |
| `argocd` | GitOps |
| `argocd-autopilot` | ArgoCD bootstrap |
| `kind` | Local clusters |
| `ktop` | Node monitor |
| `eksctl` | EKS management |

### AWS

| Package | Description |
|---------|-------------|
| `awscli` | AWS CLI |
| `localstack` | Local AWS emulation |

### Infrastructure

| Package | Description |
|---------|-------------|
| `terraform` | IaC |
| `terraform-docs` | Documentation generation |
| `tflint` | Linter |
| `tfswitch` | Version switcher |
| `pulumi` | Alternative IaC |
| `ansible` | Configuration management |
| `talosctl` | Talos OS control |

### Development

| Package | Description |
|---------|-------------|
| `go` | Go language |
| `node` | Node.js |
| `python` | Python |
| `mise` | Version manager |
| `just` | Task runner |
| `make` | Build tool |
| `bun` | JS runtime |
| `pre-commit` | Git hooks |

### Containers

| Package | Description |
|---------|-------------|
| `docker` | CLI |
| `docker-desktop` | Desktop app |

### Monitoring

| Package | Description |
|---------|-------------|
| `htop` / `btop` / `bottom` | System monitors |
| `k6` | Load testing |
| `hey` | HTTP benchmarking |

### Networking

| Package | Description |
|---------|-------------|
| `nmap` | Network scanner |
| `mtr` | Traceroute |
| `tcpdump` | Packet capture |
| `socat` | Socket relay |
| `wget` / `curl` | HTTP clients |
| `wireguard-tools` | VPN |
| `tailscale` | Mesh VPN |

### Databases

| Package | Description |
|---------|-------------|
| `postgresql@17` | PostgreSQL |
| `pgcli` | PostgreSQL CLI |
| `mycli` | MySQL CLI |
| `mongodb` | MongoDB |

### GUI Apps (Casks)

| Cask | Description |
|------|-------------|
| `aerospace` | Tiling window manager |
| `ghostty` | Terminal |
| `docker-desktop` | Docker GUI |
| `obs` | Screen recording |
| `hyperkey` | Keyboard remapper |
| `ngrok` | Tunneling |
| `gcloud-cli` | Google Cloud |
| `mongodb-compass` | MongoDB GUI |
