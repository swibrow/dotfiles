# Git

## Configuration

Git config is templated via chezmoi (`dot_gitconfig.tmpl`) with user-specific data.

### Core Settings

| Setting | Value |
|---------|-------|
| Default branch | `main` |
| Editor | `nvim` |
| Pull strategy | Rebase |
| Auto-setup remote | Yes (push auto-tracks) |
| URL rewrite | `https://github.com/` &rarr; `git@github.com:` |

### Commit Signing

All commits and tags are GPG-signed:

```ini
[commit]
  gpgSign = true
  signoff = true

[tag]
  gpgSign = true
```

The signing key is set during `chezmoi init` and stored in chezmoi data.

## Aliases

### `housekeeping`

Full repository maintenance:

```bash
git housekeeping
```

Runs: `fsck` &rarr; `fsck --unreachable` &rarr; `gc --aggressive --prune` &rarr; `prune` &rarr; `prune-packed`

### `wipeout`

Interactive branch cleanup with [gum](https://github.com/charmbracelet/gum) UI:

```bash
git wipeout
```

Presents a multi-select list of branches to delete.

## Git Worktrees (Worktrunk)

[Worktrunk](https://github.com/max-sixty/worktrunk) manages git worktrees. It auto-generates commit messages using Claude Haiku.

| Alias | Command | Action |
|-------|---------|--------|
| `wts` | `wt switch` | Switch to a worktree |
| `wtc` | `wt create` | Create a new worktree |
| `wtl` | `wt list` | List all worktrees |
| `wtr` | `wt remove` | Remove a worktree |
| `wtm` | `wt merge` | Merge a worktree |
| `wsc` | `wt switch --create -x claude` | Create worktree + open Claude |

### Commit Message Generation

Worktrunk uses Claude Haiku to auto-generate commit messages:

```toml
# ~/.config/worktrunk/config.toml
[commit.generation]
command = "CLAUDECODE= MAX_THINKING_TOKENS=0 claude -p --model=haiku ..."
```

## GitHub CLI

SSH protocol by default. Custom alias:

```bash
gh co    # Shorthand for: gh pr checkout
```

## Pre-commit Hooks

The repo uses pre-commit for:

- Trailing whitespace removal
- End-of-file fixer
- Merge conflict detection
- Private key detection
- AWS credential detection
