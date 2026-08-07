#!/usr/bin/env zsh
source "$HOME/.zprofile"

current=$(herdr pane current)
cwd=$(printf '%s' "$current" | jq -r '.result.pane.foreground_cwd // .result.pane.cwd')
workspace_id=$(printf '%s' "$current" | jq -r '.result.pane.workspace_id')
default=$(basename "$cwd")
printf 'rename workspace to [%s]: ' "$default"
read name
herdr workspace rename "$workspace_id" "${name:-$default}"
