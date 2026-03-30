# Local Scripts

Scripts in `~/.local/scripts/`, managed by chezmoi.

## Tmux Scripts

### `tmux-start.sh`

Intelligent tmux startup, used as Ghostty's launch command.

- If `main` session exists and has clients &rarr; creates new ephemeral session
- Otherwise &rarr; attaches to `main` (creating if needed)

### `tmux-sesh-window.sh`

Sesh-powered directory/session picker. Triggered by ++prefix+f++.

- Sources: zoxide history, tmux sessions, `~/dev` tree
- Filters: all / tmux sessions / zoxide / kill
- Opens as new tmux window or switches to existing session

### `tmux-claude.sh`

Claude Code launcher for tmux. Triggered by ++prefix+g++.

1. FZF picker of `~/dev` directories (2 levels deep)
2. Creates a new window with a split layout
3. Starts Claude in the right pane

### `tmux-dev.sh`

Full development environment. Triggered by ++prefix+d++.

1. FZF picker of `~/dev` directories
2. Creates a 3-pane layout: nvim (left), claude (top-right), shell (bottom-right)

### `tmux-cht.sh`

Interactive cheat sheet via [cht.sh](https://cht.sh/). Triggered by ++prefix+i++.

1. Pick a language/tool from a menu
2. Enter a query
3. Displays results in a new tmux window

### `tmux-calendar.go` / `tmux-calendar`

Go source compiled to a binary. Displays Google Calendar events in the tmux status bar via `gcalcli`.

## AWS Scripts

### `aws-eks-config.sh`

Interactive EKS cluster configuration. See [AWS docs](../cloud/aws.md#eks-configuration-script).

### `aws-rds-connect.sh`

Helper for connecting to RDS instances with environment-specific settings.

### `find-ip.sh`

Searches for an IP address across multiple AWS profiles and regions.

```bash
find-ip.sh 10.0.1.50
```

Checks profiles against regions `eu-central-1` and `eu-west-1`.

### `max-pods-calculator.sh`

From [AWS Labs](https://github.com/aws/amazon-eks-ami). Calculates max pods per node based on instance type and CNI settings.
