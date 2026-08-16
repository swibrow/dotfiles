#!/usr/bin/env zsh
source "$HOME/.zprofile"

current=$(herdr pane current)
cwd=$(printf '%s' "$current" | jq -r '.result.pane.foreground_cwd // .result.pane.cwd')
workspace_id=$(printf '%s' "$current" | jq -r '.result.pane.workspace_id')
default=$(basename "$cwd")
name=$default
# vared gives the popup full ZLE line editing (ctrl+a/ctrl+e, arrows, ctrl+w); read has none.
vared -p 'rename workspace to: ' name
herdr workspace rename "$workspace_id" "${name:-$default}"
