# Tmux

## Basics

| Setting | Value |
|---------|-------|
| Prefix | ++ctrl+space++ |
| Mouse | Enabled |
| History limit | 1,000,000 lines |
| Mode keys | Vi |
| Escape time | 0ms |

## Keybindings

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
| ++prefix+period++ | Rename current window (auto-fills basename) |

### Development

| Binding | Action |
|---------|--------|
| ++prefix+g++ | Open Claude Code in a tmux popup (pick directory with fzf) |
| ++prefix+d++ | Open full dev layout (nvim + claude + shell) |
| ++prefix+shift+c++ | Split pane and open Claude Code |
| ++prefix+i++ | Cheat sheet lookup via cht.sh |

### Worktrees

| Binding | Action |
|---------|--------|
| ++prefix+t++ | Worktrunk — switch git worktree |
| ++prefix+shift+t++ | Worktrunk — create new worktree |

## Plugins

Managed via [TPM](https://github.com/tmux-plugins/tpm) (installed automatically by chezmoi).

| Plugin | Purpose |
|--------|---------|
| tmux-sensible | Sensible defaults |
| tmux-resurrect | Save/restore sessions across reboots |
| tmux-continuum | Auto-save sessions continuously |
| tmux-fzf-url | Extract and open URLs from pane content |
| tmux-pomodoro-plus | Pomodoro timer in status bar |
| catppuccin/tmux | Catppuccin Mocha theme |

!!! tip "Installing plugins"
    After first setup, press ++prefix+shift+i++ to install all plugins via TPM.

## Status Bar

The status bar shows (left to right):

- **Left**: Session name
- **Right**: Google Calendar events, Pomodoro timer, Date/Time

The calendar widget uses `gcalcli` via a custom Go binary (`tmux-calendar`).

## Pomodoro Timer

| Setting | Value |
|---------|-------|
| Work duration | 25 minutes |
| Break | 5 minutes |
| Long break | 15 minutes |

Toggle with the pomodoro keybinding (configured by the plugin).

## Dev Layout (`Prefix + d`)

Opens an fzf picker for `~/dev` directories, then creates a 3-pane layout:

```
+-------------------+----------+
|                   |  claude  |
|      nvim         +----------+
|                   |  shell   |
+-------------------+----------+
```

## Claude Layout (`Prefix + g`)

Opens an fzf picker, then creates a 2-pane window:

```
+-------------------+----------+
|                   |          |
|      shell        |  claude  |
|                   |          |
+-------------------+----------+
```

## Startup

Ghostty launches with `tmux-start.sh` which:

1. If a `main` session exists and has active clients → creates a new ephemeral session
2. Otherwise → attaches to `main` (creating it if needed)

This ensures you always land in tmux when opening Ghostty.
