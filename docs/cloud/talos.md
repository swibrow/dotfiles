# Talos

[Talos Linux](https://www.talos.dev/) is a minimal, immutable OS designed for Kubernetes. These functions manage Talos clusters.

## Context Switching

### `tx` — Switch Context

```bash
tx                # List available contexts
tx my-cluster     # Switch to specific context
```

### `txf` — Interactive Switcher

```bash
txf    # fzf-powered context selection
```

## Monitoring

### `tdash` — Dashboard

```bash
tdash              # Current node
tdash 10.0.1.5     # Specific node
```

Opens the Talos dashboard showing node health, services, and resources.

### `tuptime` — Uptime

```bash
tuptime                         # All nodes
tuptime "10.0.1.5 10.0.1.6"    # Specific nodes
```

Shows uptime in human-readable format (e.g., "2 days 5 hours 30 minutes").

## Debugging

### `tdmesg` — Kernel Messages

```bash
tdmesg 10.0.1.5               # Full dmesg output
tdmesg 10.0.1.5 "error"       # Grep for errors
tdmesg 10.0.1.5 "oom"         # Find OOM kills
```

### `tlogs` — Service Logs

```bash
tlogs 10.0.1.5                 # kubelet logs (default)
tlogs 10.0.1.5 etcd            # etcd logs
tlogs 10.0.1.5 containerd      # containerd logs
```

## Operations

### `treboot` — Reboot Node

```bash
treboot 10.0.1.5
```

Prompts for confirmation before rebooting.

## Alias

| Alias | Command |
|-------|---------|
| `t` | `talosctl` |

## Shell Completions

Talosctl completions are cached via `_cached_eval`:

```bash
_cached_eval talosctl talosctl completion zsh
```
