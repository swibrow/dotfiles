# Kubernetes

## Quick Reference

| Alias | Action |
|-------|--------|
| `k` | `kubectl` |
| `kx` | Switch context (kubectx) |
| `kns` | Switch namespace (kubens) |
| `kt` | Tail pod logs (kubetail) |
| `kgpa` | Get all pods, all namespaces |
| `kgp` | Get pods |
| `kgs` | Get services |
| `kgd` | Get deployments |
| `kgn` | Get nodes |

## Debugging

### Debug Pod

Launch an ephemeral pod for debugging:

```bash
kdebug                           # busybox in default namespace
kdebug -n kube-system            # in specific namespace
kdebug -i nicolaka/netshoot      # with custom image
kdebug -- curl http://my-svc     # run a specific command
```

### Admin Pod (Network Debugging)

Launch a [netshoot](https://github.com/nicolaka/netshoot) pod with full networking tools:

```bash
kadmin                            # in default namespace
kadmin -n kube-system             # in specific namespace
kadmin -- dig kubernetes.default  # DNS lookup
kadmin -- tcpdump -i eth0        # Packet capture
```

## Cluster Operations

### Clean Up Pods

```bash
kclean              # Delete all Succeeded pods
kclean Failed       # Delete all Failed pods
```

Or via task:

```bash
task kubectl:pods:clean    # Delete both Succeeded and Failed pods
```

### Drain Cordoned Nodes

```bash
task kubectl:drain:condoned
```

Finds all cordoned (unschedulable) nodes and drains them.

### Delete Namespaces

```bash
# By prefix
kdelete_namespaces_with_prefix dev-

# Empty namespaces
kdelete_empty_namespaces
kdelete_empty_namespaces --yes              # Skip confirmation
kdelete_empty_namespaces --prefix test-     # Only matching prefix
```

### Remove Stuck Finalizers

When a resource won't delete because of finalizers:

```bash
kremovefinalizers namespace my-stuck-ns
kremovefinalizers pod my-stuck-pod
```

## Inspection

### Pods by Node

```bash
kpodbynode ip-10-0-1-123.ec2.internal
```

### Pods by Label

```bash
kpodbylabel app=nginx
```

## K9s

[K9s](https://k9scli.io/) is a terminal UI for Kubernetes.

### Theme

Uses Catppuccin Mocha with multiple variants available:

- `catppuccin-mocha` (default)
- `catppuccin-macchiato`
- `catppuccin-frappe`
- `catppuccin-latte`
- Transparent variants
- Nord

### Custom Aliases

| Shortcut | Resource |
|----------|----------|
| `dp` | Deployments |
| `sec` | Secrets |
| `jo` | Jobs |
| `cr` | ClusterRoles |
| `crb` | ClusterRoleBindings |
| `ro` | Roles |
| `rb` | RoleBindings |
| `np` | NetworkPolicies |

### Resource Thresholds

- CPU: Warning at 70%, Critical at 90%
- Memory: Warning at 70%, Critical at 90%

### Shell Pod

K9s shell pods use `busybox:1.35.0` with:

- CPU: 100m
- Memory: 100Mi
- Namespace: default

## Inline Resource Editor

Create or apply Kubernetes manifests inline:

```bash
inline_kubectl_editor create
inline_kubectl_editor apply
```

Opens an inline editor for quick YAML editing without creating files.
