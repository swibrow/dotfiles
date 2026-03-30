# FZF & Search Tools

## FZF

[fzf](https://github.com/junegunn/fzf) is the backbone of interactive selection throughout the setup.

### Keybindings

| Key | Action |
|-----|--------|
| ++ctrl+t++ | File picker (with bat preview) |
| ++ctrl+r++ | History search (handled by atuin) |
| ++alt+c++ | Directory picker |

### Theme

Uses Catppuccin Mocha colors for consistent appearance across all fzf prompts.

### Where FZF is Used

- `af` — AWS profile selection
- `txf` — Talos context selection
- `gh-browse` — GitHub repo browser
- Tmux session picker (++prefix+f++)
- Tmux dev/claude layouts (directory selection)
- `git wipeout` — Branch deletion (via gum)
- Sesh directory picker

## Zoxide

[Zoxide](https://github.com/ajgeiss0702/zoxide) is a smarter `cd` that learns your habits.

```bash
z project      # Jump to most-used directory matching "project"
zi             # Interactive selection with fzf
```

Zoxide feeds into the sesh directory picker, making tmux session creation aware of your most-visited directories.

### Importing History

```bash
# From z.sh
zoxide import --from=z ~/.z
```

## Atuin

[Atuin](https://atuin.sh/) replaces shell history search with a SQLite-backed, fuzzy-searchable history.

### Settings

| Setting | Value |
|---------|-------|
| Search mode | Fuzzy |
| Filter mode | Global (all hosts) |
| Sync | Disabled (local only) |
| Style | Compact |
| Inline height | 30 lines |
| Keymap | Auto (vim in vim, emacs elsewhere) |

### Usage

```bash
# Start typing and press Ctrl+R for fuzzy history search
# Or use up arrow for prefix search (atuin's up-arrow is disabled,
# using zsh's built-in prefix search instead)
```

## Carapace

[Carapace](https://carapace.sh/) bridges completions from multiple shell ecosystems:

```bash
CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
```

Provides completions for tools that only ship fish or bash completers.

## Bat

[Bat](https://github.com/sharkdp/bat) is a `cat` replacement with syntax highlighting.

- Theme: Catppuccin Mocha
- Used as the preview command for fzf (++ctrl+t++)

## Yazi

[Yazi](https://yazi-rs.github.io/) is a terminal file manager.

```bash
y    # Open yazi in current directory
```
