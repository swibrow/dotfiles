# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing configuration files and utilities for a macOS development environment. The repository uses [chezmoi](https://www.chezmoi.io/) for dotfile management and includes configurations for:

- Terminal: Ghostty, Tmux, Starship prompt
- Shell: Zsh with Antidote plugin manager
- Editor: Neovim (LazyVim)
- Development tools: Git, K9s, Mise, Bat
- Window management: Aerospace
- Task automation: Taskrunner with AWS and Kubernetes utilities

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

### Task Management
The repository uses Taskrunner (go-task) for automation:
- `task` - Show available tasks
- `task dotfiles:install` - Install dotfiles
- `task dotfiles:update` - Update dotfiles from remote repository
- `task gh:repo` - Open current repository in GitHub
- `task gh:actions` - Open GitHub Actions for current repository

### AWS Tasks
- `task aws:auth <profile>` - Authenticate with AWS using aws-vault
- `task aws:list_users` - List all IAM users and their access keys
- `task eks:latestaddons <version>` - Get latest EKS addon versions for specified Kubernetes version

### Kubernetes Tasks
- `task kubectl:drain:condoned` - Drain all cordoned nodes
- `task kubectl:pods:clean` - Delete all Succeeded and Failed pods across namespaces

### Terraform Tasks
- `task tf:init` - Initialize Terraform with S3 backend (requires AWS authentication)
- `task tf:plan` - Run terraform plan with sandbox environment variables

## Architecture Notes

- Uses chezmoi for dotfile management — source files use `dot_` prefix conventions
- `dot_*` directories/files map to `.*` in home directory
- `executable_*` prefix ensures files are set executable on apply
- `private_*` prefix sets `0600` permissions
- `*.tmpl` files are processed as Go templates with chezmoi data
- `.chezmoiscripts/` contains run scripts (Homebrew install, brew bundle, etc.)
- `.chezmoiexternal.yaml` manages external dependencies (TPM for tmux)
- `.chezmoi.yaml.tmpl` prompts for user-specific data (email, GPG key)
- Secrets managed via Proton Pass CLI integration in templates
- Task definitions are split across multiple files using Taskrunner's include feature
- AWS operations assume aws-vault for credential management
- Terraform backend uses account-specific S3 bucket naming (`tf-state-{account-id}`)
