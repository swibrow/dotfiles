# Chezmoi

[Chezmoi](https://www.chezmoi.io/) manages dotfiles by maintaining a source directory (`~/.local/share/chezmoi`) and applying files to the home directory.

## File Naming Conventions

Source files use special prefixes that chezmoi interprets:

| Prefix | Effect | Example |
|--------|--------|---------|
| `dot_` | Deployed with `.` prefix | `dot_zshrc` &rarr; `~/.zshrc` |
| `executable_` | Sets file executable (755) | `executable_tmux-start.sh` &rarr; `tmux-start.sh` (executable) |
| `private_` | Sets permissions to 0600 | `private_dot_env` &rarr; `~/.env` (private) |
| `*.tmpl` | Processed as Go template | `dot_gitconfig.tmpl` &rarr; `~/.gitconfig` (templated) |
| `create_` | Only create, never update | Preserves user modifications |

Directories follow the same rules: `dot_config/` maps to `~/.config/`.

## Templates

Files ending in `.tmpl` are Go templates processed with chezmoi data. The data is defined in `.chezmoi.yaml.tmpl`:

```yaml
data:
  email: "15628653+swibrow@users.noreply.github.com"
  name: "Samuel"
  signingkey: "28257C9F"
```

These values are prompted once on first `chezmoi init` and cached. Use them in templates:

```gitconfig
# dot_gitconfig.tmpl
[user]
  email = {{ .email }}
  name = {{ .name }}
  signingkey = {{ .signingkey }}
```

## External Dependencies

`.chezmoiexternal.yaml` pulls in git repos automatically:

```yaml
".config/tmux/plugins/tpm":
  type: git-repo
  url: "https://github.com/tmux-plugins/tpm"
  refreshPeriod: 168h    # Re-pull weekly
  clone:
    args: ["--depth", "1"]
```

## Key Commands

| Command | Purpose |
|---------|---------|
| `chezmoi apply` | Apply all changes |
| `chezmoi diff` | Preview pending changes |
| `chezmoi edit ~/.zshrc` | Edit a managed file |
| `chezmoi add ~/.config/foo/bar` | Start managing a new file |
| `chezmoi update` | Pull from remote and apply |
| `chezmoi cd` | Navigate to the source directory |
| `chezmoi doctor` | Diagnose common issues |
| `chezmoi data` | Show template data |

!!! tip "Quick access"
    The shell function `cm` is a shortcut — `cm` alone runs `chezmoi cd`, and `cm <args>` forwards to `chezmoi`.

## Ignored Files

`.chezmoiignore` lists files that chezmoi should not manage — things like `README.md`, `CLAUDE.md`, `Taskfile.yaml`, and other repo-only files.

## Run Scripts

Scripts in `.chezmoiscripts/` execute during apply. The naming controls behavior:

| Prefix | Behavior |
|--------|----------|
| `run_once_before_` | Runs once, before file apply |
| `run_once_after_` | Runs once, after file apply |
| `run_onchange_before_` | Re-runs when file content changes |

The numeric prefix (`00`, `01`, `02`...) controls execution order.

## Brewfile Management

When regenerating the Brewfile after installing new packages:

```bash
brew bundle dump --file=dot_config/homebrew/Brewfile --force --no-vscode
```

!!! warning "Always use `--no-vscode`"
    The `--no-vscode` flag prevents VS Code extensions from being included in the Brewfile.
