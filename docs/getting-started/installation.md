# Installation

## One-Line Bootstrap

```bash
sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply swibrow
```

This will:

1. Install chezmoi
2. Clone the dotfiles repo to `~/.local/share/chezmoi`
3. Prompt for user-specific data (email, name, GPG key)
4. Run setup scripts in order
5. Apply all dotfiles to the home directory

## What Happens Automatically

Chezmoi runs scripts in `.chezmoiscripts/` during apply, in order:

### Phase 0: Create Directories

Creates the directory structure:

```
~/.config/
~/.local/scripts/
~/.local/bin/
```

### Phase 1: Install Homebrew

Installs Homebrew if not already present (macOS only).

### Phase 2: Install Brewfile

Runs `brew bundle` to install all packages from the [Brewfile](../reference/brewfile.md). This step is hash-tracked — it only re-runs when the Brewfile changes.

### Phase 3: Compile Go Binaries

Compiles custom Go utilities:

```bash
go build -o ~/.local/scripts/tmux-calendar ~/.local/scripts/tmux-calendar.go
```

### Phase 4: Post-Install Notes

Displays manual steps:

- Restart terminal or `source ~/.zshrc`
- Install tmux plugins: ++prefix+shift+i++
- Set up Proton Pass CLI for secrets
- Import shell history into zoxide and atuin

## Post-Install Manual Steps

### Tmux Plugins

Open tmux and install plugins:

```
Ctrl+Space, then Shift+I
```

### Shell History Migration

```bash
# Import from z (if migrating from z.sh)
zoxide import --from=z ~/.z

# Import shell history into atuin
atuin import auto
```

### GPG Key

Import your GPG key for commit signing:

```bash
gpg --import <keyfile>
```

### AWS Configuration

Set up your AWS profiles, then use `af` to switch:

```bash
af  # Interactive AWS profile switcher with SSO login
```

## Updating

Pull latest changes and apply:

```bash
chezmoi update
```

Or if you've edited files directly in the source:

```bash
chezmoi apply
```
