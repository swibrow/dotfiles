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

### Splits

Both open in the current pane's directory.

| Binding | Action |
|---------|--------|
| ++prefix+shift+backslash++ (`\|`) | Full-height split to the right |
| ++prefix+shift+minus++ (`_`) | Full-width split along the bottom |

### Sessions & Windows

| Binding | Action |
|---------|--------|
| ++prefix+f++ | Sesh picker — open directory as a new window (tab); connects to existing sessions |
| ++prefix+s++ | Sesh picker — open directory/session as a new session |
| ++prefix+shift+s++ | Scratch session popup |
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
| ++prefix+t++ | Worktrunk — switch git worktree (current repo) |
| ++prefix+shift+t++ | Worktrunk — create worktree of the **current** repo and open it as a new named tab |
| ++prefix+shift+w++ | Worktrunk — pick **any** repo, create a worktree, open it as a new tab running Claude Code |
| ++prefix+shift+x++ | Worktrunk — remove current worktree and close its tab |

++prefix+shift+t++ is pinned to the current pane's repo (`#{pane_current_path}`). Use
++prefix+shift+w++ when you want a worktree of a *different* repo than the one you're sitting in —
it picks the repo first, so it works from any session/window.

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

- **Left**: Next Google Calendar event (via `gcalcli` in `status-left`)
- **Right**: Pomodoro timer, Date/Time

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

## Worktree + Claude (`Prefix + W`)

For starting work on a new branch of a repo other than the one you're currently in:

1. fzf picker for `~/dev` repos → pick the target repo
2. Prompt for a branch name
3. Worktrunk creates the worktree (`wt -C <repo> switch --create <branch> --no-cd`)
4. Opens a new window named after the branch, in the worktree, running `claude`

```
+--------------------------------+
| <branch>                       |
|  claude (in <repo> worktree)   |
|                                |
+--------------------------------+
```

## Startup

Ghostty launches with `tmux-sesh start` which:

1. Attaches to the `main` session if it exists and is unattached (creating it if needed)
2. Otherwise → opens the sesh picker to connect to a session or directory

This ensures you always land in tmux when opening Ghostty.
