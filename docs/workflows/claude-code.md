# Claude Code

[Claude Code](https://code.claude.com/) is integrated throughout the terminal workflow as an AI coding assistant.

## Dual Account Setup

Two separate Claude Code configurations — personal and work — managed via mise:

| Directory | Config Dir | Account |
|-----------|-----------|---------|
| `~/dev/dnd-it/**` | `~/.claude_work` | Work (OAuth) |
| `~/dev/tx-pts-dai/**` | `~/.claude_work` | Work (OAuth) |
| Everything else | `~/.claude` | Personal (OAuth) |

**How it works:** Mise sets `CLAUDE_CONFIG_DIR` based on the current directory. Each config dir has its own OAuth session, settings, history, and MCP servers.

The mise config in each work directory:

```toml
# ~/dev/dnd-it/.mise.toml
[env]
CLAUDE_CONFIG_DIR = "{{env.HOME}}/.claude_work"
ANTHROPIC_API_KEY = "{{exec(command='security find-generic-password -s anthropic-api-key -w')}}"
```

The API key is stored in the macOS Keychain and injected at shell time — never committed to disk. Use the [`keyring-set`](../shell/functions.md#keychain-helpers) helper to manage it:

```bash
keyring-set anthropic-api-key
```

!!! note "First-time setup"
    The first time you run `claude` in a work directory, it will prompt for OAuth login with your work account.

## Tmux Integration

| Keybinding | Action |
|-----------|--------|
| ++prefix+g++ | Open Claude in a popup (pick directory with fzf) |
| ++prefix+d++ | Full dev layout (nvim + claude + shell) |
| ++prefix+shift+c++ | Split current pane and open Claude |

### Dev Layout

```
+-------------------+----------+
|                   |  claude  |
|      nvim         +----------+
|                   |  shell   |
+-------------------+----------+
```

### Claude Layout

```
+-------------------+----------+
|                   |          |
|      shell        |  claude  |
|                   |          |
+-------------------+----------+
```

## Settings

### Personal (`~/.claude/settings.json`)

```json
{
  "enableAllProjectMcpServers": true,
  "enabledMcpjsonServers": ["supabase", "github"],
  "statusLine": {
    "type": "command",
    "command": "wt list statusline --format=claude-code"
  },
  "enabledPlugins": {
    "code-documentation@claude-code-workflows": true,
    "cloud-infrastructure@claude-code-workflows": true,
    "gopls-lsp@claude-plugins-official": true,
    "frontend-design@claude-plugins-official": true,
    "worktrunk@worktrunk": true
  }
}
```

### MCP Servers

GitHub MCP server runs in Docker:

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
               "ghcr.io/github/github-mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_ACCESS_TOKEN}"
      }
    }
  }
}
```

## Plugins

| Plugin | Purpose |
|--------|---------|
| code-documentation | Documentation generation workflows |
| cloud-infrastructure | Cloud/infra tooling and patterns |
| gopls-lsp | Go language server integration |
| frontend-design | Frontend design tools |
| worktrunk | Git worktree management |

## Worktrunk Integration

The status line shows current worktree info:

```
wt list statusline --format=claude-code
```

Worktrunk also uses Claude Haiku for auto-generating commit messages.
