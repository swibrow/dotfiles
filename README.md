# dotfiles

Managed with [chezmoi](https://www.chezmoi.io/).

## Quick Install (new machine)

```shell
sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply swibrow
```

## Usage

```shell
# Edit a dotfile (opens source, then apply)
chezmoi edit ~/.zshrc
chezmoi apply

# Preview changes before applying
chezmoi diff

# Pull latest from remote and apply
chezmoi update

# Add a new file to chezmoi management
chezmoi add ~/.config/some/file

# Check for issues
chezmoi doctor
```

## Structure

- `dot_*` — files/dirs deployed with `.` prefix (e.g. `dot_zshrc` → `~/.zshrc`)
- `executable_*` — files set executable on apply
- `private_*` — files set to `0600` permissions
- `*.tmpl` — Go template files (processed with chezmoi data)
- `.chezmoiscripts/` — run scripts (install Homebrew, brew bundle, etc.)
- `.chezmoiexternal.yaml` — external dependencies (TPM)

## Resources

- https://www.chezmoi.io/
- https://github.com/unixorn/awesome-zsh-plugins
