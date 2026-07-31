#!/bin/sh
# Ensure Claude Code's memini MCP server sends a per-repo namespace header.
# The value ${MEMINI_NAMESPACE} is interpolated by Claude at launch from the
# environment; the zsh memini hook exports it per git repo. ~/.claude.json is
# app-owned state (not chezmoi-managed), so patch just the one key idempotently.
set -eu

claude_json="$HOME/.claude.json"
[ -f "$claude_json" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

tmp=$(mktemp)
jq '.mcpServers.memini = {
      "type": "http",
      "url": "https://memini-api.wibrow.dev/mcp",
      "headers": {
        "Authorization": "Bearer ${MEMINI_API_KEY}",
        "X-Memini-Namespace": "${MEMINI_NAMESPACE}"
      }
    }' "$claude_json" >"$tmp" && mv "$tmp" "$claude_json"
