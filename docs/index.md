# Dotfiles

Personal macOS development environment managed with [chezmoi](https://www.chezmoi.io/). Optimized for cloud-native development, terminal-first workflows, and fast shell startup.

## What's Inside

<div class="grid cards" markdown>

-   :material-console:{ .lg .middle } __Shell__

    ---

    Zsh with no plugin manager, autosuggestions and syntax highlighting from Homebrew. Cached tool inits for <300ms startup.

    [:octicons-arrow-right-24: Shell setup](shell/index.md)

-   :material-tools:{ .lg .middle } __Tools__

    ---

    Tmux, Neovim (LazyVim), Ghostty, Starship prompt, Aerospace tiling, and more.

    [:octicons-arrow-right-24: Tool configs](tools/index.md)

-   :material-cloud:{ .lg .middle } __Cloud & Infra__

    ---

    AWS, Kubernetes, Terraform, and Talos OS helpers, functions, and task automation.

    [:octicons-arrow-right-24: Cloud workflows](cloud/index.md)

-   :material-rocket-launch:{ .lg .middle } __Workflows__

    ---

    Development flows, Claude Code integration, worktree management, and task automation.

    [:octicons-arrow-right-24: Workflows](workflows/index.md)

</div>

## Quick Reference

| Action | Command |
|--------|---------|
| Install on new machine | `sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply swibrow` |
| Apply changes | `chezmoi apply` |
| Preview changes | `chezmoi diff` |
| Edit a dotfile | `chezmoi edit ~/.zshrc` |
| Switch AWS profile | `af` |
| Switch k8s context | `kx` |
| Open dev environment | ++prefix+d++ in tmux |
| Open Claude Code | ++prefix+g++ in tmux |

!!! info "Tmux prefix"
    The tmux prefix is ++ctrl+space++ throughout this documentation, shown as ++prefix++.

## Stack at a Glance

| Layer | Tool |
|-------|------|
| Terminal | Ghostty |
| Multiplexer | Tmux |
| Shell | Zsh |
| Prompt | Starship |
| Editor | Neovim (LazyVim) |
| Window Manager | Aerospace |
| Dotfile Manager | Chezmoi |
| Version Manager | Mise |
| AI Assistant | Claude Code |
| Theme | Catppuccin Mocha |
