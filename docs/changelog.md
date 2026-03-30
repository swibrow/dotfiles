# Changelog

Notable changes to the dotfiles setup.

## 2026-03-30

### Added
- Documentation site with MkDocs Material, deployed to GitHub Pages
- Dual Claude Code configuration (personal/work) via mise + `CLAUDE_CONFIG_DIR`
- Switched mise from shims to `mise activate` for env var support

### Removed
- Magnet app remnants (preferences and defaults)

## 2026-03-18

### Changed
- Improved terminal startup command (`tmux-start.sh`)

## 2026-03-09

### Added
- `kdebug` function for ephemeral debug pods (busybox, custom images)
- `kadmin` function for network debugging pods (netshoot)

## 2026-03-07

### Added
- Worktrunk integration: tmux keybindings, sesh picker, worktree management
- Worktrunk config with Claude Haiku commit message generation
- Claude Code settings and MCP servers added to dotfile management
- Worktrunk statusline in Claude Code

### Fixed
- Worktrunk popup flashing when no worktrees exist
- Worktrunk errors now show in popup instead of flashing

### Changed
- Sesh picker opens projects as new tmux windows instead of sessions

## 2026-03-04

### Changed
- Migrated to chezmoi for dotfile management
- General cleanup and restructuring

## 2025-09-03

### Changed
- Reduced Ghostty mouse scroll speed (multiplier: 0.5x)

## 2025-08-15

### Improved
- AWS SSO profile switching flow (`af` function)

## 2025-06-23

### Changed
- Updated global gitignore patterns

## 2025-05-09

### Added
- Terraform helper functions (`tf_init`, `tf_plan`, `tf_apply`, `tf_destroy`, `clean_terraform`)

## 2025-04-02

### Added
- Terraform plugin cache directory (`TF_PLUGIN_CACHE_DIR`)

## 2025-03-21

### Added
- Terraform module in Starship prompt

## 2025-02-25

### Added
- Mise version manager for tool management (Python, Node, Go, uv)

## 2025-01-16

### Fixed
- Aerospace window spacing

## 2024-12-17

### Added
- Ghostty terminal emulator configuration (Catppuccin Mocha theme)

## 2024-10-09

### Added
- Catppuccin themes for K9s, bat, FZF, and other tools

## 2024-09-27

### Added
- Carapace completion engine with shell bridges
