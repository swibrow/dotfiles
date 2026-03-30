# Brewfile

All packages managed by Homebrew, defined in `~/.config/homebrew/Brewfile`.

## Regenerating

After installing new packages:

```bash
brew bundle dump --file=dot_config/homebrew/Brewfile --force --no-vscode
```

!!! warning
    Always use `--no-vscode` to exclude VS Code extensions.

The Brewfile is auto-installed during `chezmoi apply` via a hash-tracked run script.

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
| `aws-vault` | Credential management |
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
