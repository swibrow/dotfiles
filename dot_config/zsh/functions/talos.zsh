# Switch talosctl context (like kubectx for talos)
tx() {
  if [[ -z "$1" ]]; then
    talosctl config contexts
  else
    talosctl config context "$1"
    echo "Switched to talos context: $1"
  fi
}

# Interactive talos context switch with fzf
txf() {
  local ctx
  ctx=$(talosctl config contexts 2>/dev/null | grep -v '^CURRENT' | awk '{print ($1 == "*" ? $2 : $1)}' | fzf --prompt="talos context> ")
  [[ -n "$ctx" ]] && talosctl config context "$ctx" && echo "Switched to talos context: $ctx"
}

# Show talos node dashboard (live)
tdash() {
  talosctl dashboard ${1:+-n "$1"}
}

# Quick dmesg search on a node
tdmesg() {
  local node="$1"
  shift
  if [[ -z "$node" ]]; then
    echo "Usage: tdmesg <node-ip> [grep pattern]"
    return 1
  fi
  if [[ -n "$1" ]]; then
    talosctl dmesg -n "$node" | grep -iE "$*"
  else
    talosctl dmesg -n "$node" | tail -50
  fi
}

# Show talos node uptime
tuptime() {
  local nodes
  if [[ -n "$1" ]]; then
    nodes="$1"
  else
    nodes=$(talosctl get members -o json 2>/dev/null | jq -rs '[.[].spec.addresses[0]] | unique | .[]')
  fi
  for node in ${(f)nodes}; do
    local raw=$(talosctl -n "$node" read /proc/uptime 2>/dev/null | awk '{print $1}')
    if [[ -n "$raw" ]]; then
      local days=$((${raw%.*} / 86400))
      local hours=$(( (${raw%.*} % 86400) / 3600 ))
      local mins=$(( (${raw%.*} % 3600) / 60 ))
      printf "%-16s %dd %dh %dm\n" "$node" "$days" "$hours" "$mins"
    else
      printf "%-16s unreachable\n" "$node"
    fi
  done
}

# Quick node logs (kernel + system)
tlogs() {
  local node="$1"
  if [[ -z "$node" ]]; then
    echo "Usage: tlogs <node-ip>"
    return 1
  fi
  talosctl logs -n "$node" ${2:-kubelet}
}

# Reboot a talos node with confirmation
treboot() {
  local node="$1"
  if [[ -z "$node" ]]; then
    echo "Usage: treboot <node-ip>"
    return 1
  fi
  echo "Rebooting node $node..."
  read -q "REPLY?Are you sure? (y/n) "
  echo
  [[ $REPLY =~ ^[Yy]$ ]] && talosctl reboot -n "$node" --wait
}
