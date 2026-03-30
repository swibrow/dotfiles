# Ghostty

[Ghostty](https://ghostty.org/) is the terminal emulator.

## Settings

| Setting | Value |
|---------|-------|
| Theme | Catppuccin Mocha |
| Font size | 20 |
| Background blur | 20px |
| Mouse scroll multiplier | 0.5x |
| Hide mouse while typing | Yes |
| Cursor click to move | Yes |
| macOS Option as Alt | Yes |

## Keybindings

| Binding | Action |
|---------|--------|
| ++cmd+shift+period++ | Toggle quick terminal (drop-down) |
| ++shift+enter++ | Send literal newline |

## Startup

Ghostty launches with:

```bash
/bin/zsh -lc tmux-start.sh
```

This opens a login shell that runs `tmux-start.sh`, which attaches to (or creates) a tmux session. You're always in tmux when using Ghostty.

## Configuration

Edit `~/.config/ghostty/config` or via chezmoi:

```bash
chezmoi edit ~/.config/ghostty/config
```
