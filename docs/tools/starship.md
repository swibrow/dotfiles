# Starship Prompt

[Starship](https://starship.rs/) provides a fast, customizable prompt with context-aware modules.

## Layout

```
directory | git_branch | git_status |  spacer  | languages | k8s | aws | duration
                                                                               ➜
```

## Modules

### Directory
- Bold dark blue
- Truncated to 3 levels
- Folder substitutions: Documents, Downloads, Music, Pictures mapped to icons

### Git
- **Branch**: Green with  icon
- **Status**: Red indicators for modified/staged/untracked

### AWS
- Yellow with  icon
- Region aliases for compact display:

| Region | Alias |
|--------|-------|
| `eu-west-1` | IE |
| `eu-central-1` | FR |
| `us-east-1` | VA |

### Kubernetes
- Blue with context and namespace
- Shows current cluster and namespace

### Languages
Shown when relevant files are detected:

- Lua, Go, Python, Terraform

### Command Duration
- Shown for commands taking >500ms
- Displays execution time

### Prompt Character
- Green `➜` on success
- Red on error

## Theme

Uses **Catppuccin Mocha** palette throughout.

## Configuration

Edit `~/.config/starship/starship.toml` or via chezmoi:

```bash
chezmoi edit ~/.config/starship/starship.toml
```
