# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files and utilities for a macOS development environment. The repository uses [chezmoi](https://www.chezmoi.io/) for dotfile management and includes configurations for:

- Terminal: Ghostty, Tmux, Starship prompt
- Shell: Zsh (no plugin manager — autosuggestions and syntax highlighting from Homebrew)
- Editor: Neovim (LazyVim)
- Development tools: Git, K9s, Mise, Bat
- Window management: Aerospace
- Personal CLI tools and tmux popup scripts in `dot_local/bin/` (deployed to `~/.local/bin`)

## Key Commands

### chezmoi Workflow
- `chezmoi apply` - Apply dotfiles from source to home directory
- `chezmoi diff` - Preview changes before applying
- `chezmoi edit <file>` - Edit a managed dotfile (e.g. `chezmoi edit ~/.zshrc`)
- `chezmoi add <file>` - Add a new file to chezmoi management
- `chezmoi update` - Pull latest from remote and apply
- `chezmoi doctor` - Check for common issues

### Installation (new machine)
```shell
sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply swibrow
```

### Scripts (`~/.local/bin`, on PATH via `.zprofile`)
- `tmux-sesh <connect|window|start>` - sesh/fzf session picker (tmux bindings `s`/`f`; Ghostty launches `tmux-sesh start`)
- `tmux-workspace <claude|dev>` - pick a `~/dev` project, open tmux window with claude/nvim layout (bindings `g`/`d`)
- `tmux-cht`, `tmux-notes`, `tmux-scratch`, `tmux-bins`, `tmux-worktree-claude` - other tmux popup tools
- `aws-eks-config` - interactive EKS kubeconfig setup (also via `aws eks-config` alias)
- `aws-rds-connect` - interactive RDS connection via Secrets Manager
- `kubelog` - interactive kubectl log tailer
- `keychain-secret` - macOS keychain secret helper
- `claude-work`, `claude-tmux-mark` - Claude Code helpers

AWS profile switching uses the `af` shell function (AWS SSO via the native CLI); see `dot_config/zsh/functions/general.zsh`. Kubernetes helpers (`kclean`, `kdebug`, `kadmin`, etc.) live in `dot_config/zsh/functions/kubectl.zsh`.

### Brewfile Management
- When regenerating the Brewfile, always use `--no-vscode` to exclude VS Code extensions:
  ```shell
  brew bundle dump --file=dot_config/homebrew/Brewfile --force --no-vscode
  ```
- The Brewfile is auto-installed by chezmoi via `.chezmoiscripts/run_onchange_before_02-install-brewfile.sh.tmpl`

## Architecture Notes

- Uses chezmoi for dotfile management — source files use `dot_` prefix conventions
- `dot_*` directories/files map to `.*` in home directory
- `executable_*` prefix ensures files are set executable on apply
- `private_*` prefix sets `0600` permissions
- `*.tmpl` files are processed as Go templates with chezmoi data
- `.chezmoiscripts/` contains run scripts (Homebrew install, brew bundle, etc.)
- `.chezmoiexternal.yaml` manages external dependencies (TPM for tmux)
- `.chezmoi.yaml.tmpl` prompts for user-specific data (email, GPG key)
- Secrets stored in macOS login keychain (service=`env`, account=VAR_NAME); managed via `keychain-secret` helper and read by mise `exec()` with `cache_key`. Alternatively age-encrypted inline in the mise config via `mise run secret:set` / `secret:rm` (key at `~/.config/mise/age.txt`, not chezmoi-managed)
- AWS credentials managed via AWS SSO (`aws sso login`); profile switching via the `af` function
- Terraform backend uses account-specific S3 bucket naming (`tf-state-{account-id}`)
