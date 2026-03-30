# Aerospace

[Aerospace](https://github.com/nikitabobko/AeroSpace) is a tiling window manager for macOS.

## Basics

- Starts at login
- Default layout: Tiles (horizontal)
- Uses ++alt++ as the primary modifier

## Keybindings

### Window Focus

| Binding | Action |
|---------|--------|
| ++alt+h++ | Focus left |
| ++alt+j++ | Focus down |
| ++alt+k++ | Focus up |
| ++alt+l++ | Focus right |

### Window Movement

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

### Resize

| Binding | Action |
|---------|--------|
| ++alt+shift+minus++ | Decrease size by 50 |
| ++alt+shift+equal++ | Increase size by 50 |

### Workspaces

| Binding | Workspace |
|---------|-----------|
| ++alt+1++ to ++alt+5++ | Workspaces 1-5 |
| ++alt+f++ | Terminal (Ghostty) |
| ++alt+d++ | Editor (VS Code) |
| ++alt+r++ | Browser (Firefox/Chrome) |
| ++alt+g++ | Browser (Zen) |
| ++alt+3++ | Chat (Slack) |
| ++alt+m++ | Chat (Discord) |
| ++alt+tab++ | Workspace switcher |

Move window to workspace: ++alt+shift++ + the workspace key.

## App Assignments

Apps automatically open in their assigned workspace:

| App | Workspace |
|-----|-----------|
| Ghostty | F |
| Obsidian | 1 |
| Slack | 3 |
| Discord | M |
| VS Code | D |
| Firefox, Chrome | R |
| Zen Browser | G |
| iPhone Simulator | 4 |
| Spotify | 5 / Y |

## Service Mode

++alt+shift+semicolon++ enters service mode:

- Flatten workspace containers
- Toggle floating windows
- Close all windows
