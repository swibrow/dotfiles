# Keybindings

All keyboard shortcuts across the terminal environment.

## Tmux (Prefix: ++ctrl+space++)

### Navigation

| Binding | Action |
|---------|--------|
| ++prefix+h++ | Focus left pane |
| ++prefix+j++ | Focus down pane |
| ++prefix+k++ | Focus up pane |
| ++prefix+l++ | Focus right pane |

### Sessions & Windows

| Binding | Action |
|---------|--------|
| ++prefix+f++ | Sesh directory/session picker |
| ++prefix+shift+f++ | Window switcher |
| ++prefix+period++ | Rename current window |

### Development

| Binding | Action |
|---------|--------|
| ++prefix+g++ | Open Claude Code (fzf directory picker) |
| ++prefix+d++ | Full dev layout (nvim + claude + shell) |
| ++prefix+shift+c++ | Split pane with Claude Code |
| ++prefix+i++ | Cheat sheet lookup (cht.sh) |

### Worktrees

| Binding | Action |
|---------|--------|
| ++prefix+t++ | Switch worktree (worktrunk) |
| ++prefix+shift+t++ | Create new worktree |

### Plugins

| Binding | Action |
|---------|--------|
| ++prefix+shift+i++ | Install tmux plugins (TPM) |

## Aerospace (Modifier: ++alt++)

### Focus

| Binding | Action |
|---------|--------|
| ++alt+h++ | Focus left |
| ++alt+j++ | Focus down |
| ++alt+k++ | Focus up |
| ++alt+l++ | Focus right |

### Move

| Binding | Action |
|---------|--------|
| ++alt+shift+h++ | Move window left |
| ++alt+shift+j++ | Move window down |
| ++alt+shift+k++ | Move window up |
| ++alt+shift+l++ | Move window right |

### Layout

| Binding | Action |
|---------|--------|
| ++alt+slash++ | Toggle tiles / accordion |
| ++alt+comma++ | Toggle accordion orientation |
| ++alt+shift+minus++ | Decrease size |
| ++alt+shift+equal++ | Increase size |

### Workspaces

| Binding | Workspace |
|---------|-----------|
| ++alt+f++ | Terminal (Ghostty) |
| ++alt+d++ | Editor (VS Code) |
| ++alt+r++ | Browser |
| ++alt+g++ | Zen Browser |
| ++alt+1++ | Obsidian |
| ++alt+3++ | Slack |
| ++alt+m++ | Discord |
| ++alt+tab++ | Workspace switcher |

## Shell (Zsh)

| Binding | Action |
|---------|--------|
| ++up++ | Prefix history search backward |
| ++down++ | Prefix history search forward |
| ++ctrl+t++ | FZF file picker |
| ++ctrl+r++ | Atuin history search |
| ++alt+c++ | FZF directory picker |

## Ghostty

| Binding | Action |
|---------|--------|
| ++cmd+shift+period++ | Toggle quick terminal |
| ++shift+enter++ | Send literal newline |
