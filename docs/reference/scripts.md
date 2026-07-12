# Local Scripts

Scripts in `~/.local/bin/`, managed by chezmoi.

## Tmux Scripts

### `tmux-sesh`

Single entry point for sesh session/directory picking:

```bash
tmux-sesh connect    # Pick, then sesh connect (new/existing session) — Prefix + s
tmux-sesh window     # Pick, open directories as new tmux windows — Prefix + f
tmux-sesh start      # Attach to "main" if unattached, otherwise pick — Ghostty startup
```

- Sources: zoxide history, tmux sessions, `~/dev` tree
- Filters: all / tmux sessions / zoxide / kill

### `tmux-workspace`

Pick a project under `~/dev` and open it in a new tmux window with a layout:

```bash
tmux-workspace claude    # shell left, claude right — Prefix + g
tmux-workspace dev       # nvim left, claude top-right, shell bottom-right — Prefix + d
```

### `tmux-worktree-claude`

Pick a repo under `~/dev`, create a git worktree via Worktrunk, and open a new tmux window in it running Claude. Triggered by ++prefix+shift+w++.

### `tmux-cht`

Interactive cheat sheet via [cht.sh](https://cht.sh/). Triggered by ++prefix+i++.

1. Pick a language/tool from a menu
2. Enter a query
3. Displays results in a new tmux window

### `tmux-scratch`

Persistent `scratch` tmux session opened in a popup — state survives popup close. Triggered by ++prefix+shift+s++.

### `tmux-notes`

Fuzzy-find notes in the Obsidian vault and open in `$EDITOR`; ++ctrl+n++ creates a new note in `inbox/`.

### `tmux-bins`

Fuzzy-pick an executable from `$PATH` and run it in a popup.

## Claude Code Scripts

### `claude-tmux-mark`

Claude Code hook that marks the containing tmux window with agent state (needs input, done, running).

### `claude-work`

Launches the Claude desktop app with the work configuration (`CLAUDE_CONFIG_DIR=~/.claude_work`).

## AWS Scripts

### `aws-eks-config`

Interactive EKS cluster configuration. See [AWS docs](../cloud/aws.md#eks-configuration-script).

### `aws-rds-connect`

Interactive RDS connection tool — picks an instance and a Secrets Manager secret for credentials via fzf.

### `max-pods-calculator`

From [AWS Labs](https://github.com/aws/amazon-eks-ami). Calculates max pods per node based on instance type and CNI settings.

## Utilities

### `keychain-secret`

Manages environment secrets in the macOS login keychain (service `env`, account = variable name):

```bash
keychain-secret set GITHUB_ACCESS_TOKEN    # Prompt and store
keychain-secret get GITHUB_ACCESS_TOKEN    # Print value
```

Read by mise configs via `exec()` to inject secrets as environment variables.

### `kubelog`

Interactive kubectl log tailer — pick resource type, namespace, and resource via fzf.

### `browser-open`

Opens a URL in the right browser profile (work vs personal) based on the URL and current directory.

### `keyfreq.swift` / `keyfreq`

Swift source compiled to a binary by a chezmoi script. Logs keyboard usage frequency via a LaunchAgent.
