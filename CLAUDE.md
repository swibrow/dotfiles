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
- `brewfile-sync <add|remove> <pkg>...` - add/remove a single Brewfile entry; called automatically by the `brew` wrapper function in `dot_config/zsh/functions/general.zsh`
- `aws-rds-connect` - interactive RDS connection via Secrets Manager (shares `aws-common.sh`)
- `kubelog` - interactive kubectl log tailer
- `keychain-secret` - macOS keychain secret helper
- `claude-work`, `claude-tmux-mark` - Claude Code helpers

AWS profile switching uses the `af` shell function (AWS SSO via the native CLI), role assumption `aws-assume`/`aws-unassume`; see `dot_config/zsh/functions/general.zsh`. EKS/profile/role pickers are fzf-based `aws` CLI aliases in `dot_aws/cli/alias`. Kubernetes helpers (`kclean`, `kdebug`, `kadmin`, etc.) live in `dot_config/zsh/functions/kubectl.zsh`.

### Brewfile Management
- `brew install` / `brew uninstall` are wrapped in zsh and mirrored into the Brewfiles by `brewfile-sync`, so a later `brew bundle` cannot resurrect something you removed. New entries are copied verbatim from `brew bundle dump` and routed: work taps -> private Brewfile, casks -> `Brewfile.macos`, rest -> `Brewfile`. Only interactive zsh is wrapped; after installing from a script, run `brewfile-sync add <pkg>` by hand.
- The Brewfiles live at `homebrew/Brewfile` and `homebrew/Brewfile.macos` in the source dir, `.chezmoiignore`d so chezmoi does not deploy them. `~/.config/homebrew/*` are symlinks back to them (`dot_config/homebrew/symlink_Brewfile*.tmpl`) and `HOMEBREW_BUNDLE_FILE` points there, so every `brew bundle` subcommand reads and writes the repo directly.
- When regenerating a Brewfile, always use `--no-vscode` to exclude VS Code extensions:
  ```shell
  brew bundle dump --force --no-vscode
  ```
- The Brewfiles are auto-installed by chezmoi via `.chezmoiscripts/run_onchange_before_02-install-brewfile.sh.tmpl`, which passes `--no-upgrade` so an apply never upgrades packages behind your back
- A dump re-adds the work tap and its formulae. This repo is public: move those lines back into `~/.config/dotfiles-private/Brewfile` before committing.

## Private Layer

This repo is public. Two things must not land here: secret env values, and strings naming the employer, its GitHub orgs, its domains, or the work email inside absolute paths. The current list of those strings is in `~/.config/dotfiles-private/work.zsh` — check a change against it before committing. Everything else — tool config, aliases, completions — stays public even if it is only useful at work.

The excluded content lives in a private repo cloned to `~/.config/dotfiles-private` by `.chezmoiexternal.yaml`: `mise.toml` (age-encrypted secrets, symlinked into `~/.config/mise/conf.d/`), `work.zsh` (`work_orgs`, `GH_DEFAULT_ORG`; sourced by `.zshrc` and `browser-open`), `finicky-work.js` (inlined by `dot_finicky.js.tmpl`), `claude_work/CLAUDE.md`, `Brewfile`. Public config must degrade gracefully when it is absent. Use `$HOME` or `{{ .chezmoi.homeDir }}` rather than absolute `/Users/...` paths.

## Architecture Notes

- Uses chezmoi for dotfile management — source files use `dot_` prefix conventions
- `dot_*` directories/files map to `.*` in home directory
- `executable_*` prefix ensures files are set executable on apply
- `private_*` prefix sets `0600` permissions
- `*.tmpl` files are processed as Go templates with chezmoi data
- `.chezmoiscripts/` contains run scripts (Homebrew install, brew bundle, etc.)
- `.chezmoiexternal.yaml` manages external dependencies (TPM for tmux)
- `.chezmoi.yaml.tmpl` prompts for user-specific data (email, GPG key) and resolves the active machine `profile` (`osx` on macOS, always; prompted on other OSes, defaulting to `linux-dev`). `.profile` gates which packages (Brewfile vs Brewfile.macos) and macOS-only app configs get installed — see `.chezmoiignore`
- Secrets stored in macOS login keychain (service=`env`, account=VAR_NAME); managed via `keychain-secret` helper and read by mise `exec()` with `cache_key`. Alternatively age-encrypted inline in the mise config via `mise run secret:set` / `secret:rm` (key at `~/.config/mise/age.txt`, not chezmoi-managed)
- AWS credentials managed via AWS SSO (`aws sso login`); profile switching via the `af` function
- Terraform backend uses account-specific S3 bucket naming (`tf-state-{account-id}`)
