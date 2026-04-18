# Shell Functions

Functions are organized by domain across four files in `~/.config/zsh/functions/`.

## General (`general.zsh`)

### `cm` — Chezmoi Shortcut

```bash
cm          # Navigate to chezmoi source directory
cm apply    # Forwards to: chezmoi apply
cm diff     # Forwards to: chezmoi diff
```

### `af` — AWS Profile Switcher

Interactive AWS profile selector with SSO login:

```bash
af
```

1. Lists all AWS profiles via `fzf`
2. Exports `AWS_PROFILE`
3. Attempts `aws sts get-caller-identity`
4. If session expired, triggers `aws sso login`
5. Displays account and user info on success

### `gh-browse` — GitHub Repo Browser

```bash
gh-browse myorg    # Browse repos in GitHub org interactively
```

Uses `gh` CLI and `fzf` to select and open repos.

### PostgreSQL Docker Helpers

Spin up PostgreSQL instances in Docker for local development:

| Function | Usage | Description |
|----------|-------|-------------|
| `pg_up` | `pg_up [port] [version] [name] [db] [user] [pass]` | Start a PostgreSQL container |
| `pg_down` | `pg_down [name]` | Stop container |
| `pg_status` | `pg_status [name]` | Show container status |
| `pg_logs` | `pg_logs [name] [lines]` | View logs |
| `pg_exec` | `pg_exec [name] [db] [user]` | Open psql shell |
| `pg_backup` | `pg_backup [name] [db] [user] [file]` | Backup database |
| `pg_restore` | `pg_restore [name] [db] [user] <file>` | Restore from backup |
| `pg_list` | `pg_list` | List all PostgreSQL containers |
| `pg_shell` | `pg_shell [name]` | Bash into container |
| `pg_help` | `pg_help` | Show help |

**Defaults:** port `5432`, PostgreSQL `17`, container `postgres-dev`, db `devdb`, user `devuser`, password `devpass`.

```bash
# Quick start with defaults
pg_up

# Custom setup
pg_up 5433 16 myproject mydb myuser mypass

# Backup and restore
pg_backup myproject mydb myuser ./backup.sql
pg_restore myproject mydb myuser ./backup.sql
```

### `cloner` — Clone All Org Repos

```bash
cloner <github_token> <org_name> [page]
```

Clones all repositories from a GitHub organization.

### `git_mirror_to_org` — Mirror Repos Between Orgs

```bash
git_mirror_to_org source_org repo_name target_org [visibility]
```

Mirrors a repository from one GitHub org to another.

### Keychain Helpers

Wrappers around macOS `security` for storing and retrieving secrets in the system keychain:

| Function | Usage | Description |
|----------|-------|-------------|
| `keyring-set` | `keyring-set <service> [value]` | Store a secret (prompts for hidden input if value omitted) |
| `keyring-get` | `keyring-get <service>` | Retrieve a secret |
| `keyring-del` | `keyring-del <service>` | Delete a secret |

```bash
# Store a secret (prompted, hidden input)
keyring-set anthropic-api-key

# Store inline
keyring-set anthropic-api-key sk-ant-...

# Retrieve
keyring-get anthropic-api-key

# Delete
keyring-del anthropic-api-key
```

Used by mise configs to inject secrets as environment variables without storing them in plaintext. See [Claude Code — Dual Account Setup](../workflows/claude-code.md#dual-account-setup).

### `eks_config` — Configure EKS Kubeconfig

```bash
eks_config my-cluster my-alias
```

Adds an EKS cluster to kubeconfig with an optional alias.

---

## Kubernetes (`kubectl.zsh`)

### `kdebug` — Debug Pod

Launch an ephemeral debug pod:

```bash
kdebug                           # busybox in default namespace
kdebug -n kube-system            # busybox in kube-system
kdebug -i nicolaka/netshoot      # custom image
kdebug -- curl http://my-svc     # run a command
```

### `kadmin` — Admin Pod

Launch a netshoot pod for network debugging:

```bash
kadmin                           # netshoot in default namespace
kadmin -n kube-system            # in specific namespace
kadmin -- dig kubernetes.default # run DNS lookup
```

### `kclean` — Delete Pods by Status

```bash
kclean              # Delete Succeeded pods
kclean Failed       # Delete Failed pods
```

### `kpodbynode` — Pods on a Node

```bash
kpodbynode ip-10-0-1-123.ec2.internal
```

### `kpodbylabel` — Pods by Label

```bash
kpodbylabel app=nginx
```

### `kremovefinalizers` — Remove Finalizers

```bash
kremovefinalizers namespace my-stuck-namespace
```

Removes all finalizers from a stuck resource to allow deletion.

### `kdelete_namespaces_with_prefix` — Bulk Namespace Delete

```bash
kdelete_namespaces_with_prefix dev-
```

Finds and deletes all namespaces matching a prefix (with confirmation).

### `kdelete_empty_namespaces` — Clean Empty Namespaces

```bash
kdelete_empty_namespaces                  # Interactive confirmation
kdelete_empty_namespaces --yes            # Skip confirmation
kdelete_empty_namespaces --prefix test-   # Only matching prefix
```

### `inline_kubectl_editor` — Inline Resource Editor

```bash
inline_kubectl_editor create    # Create resource from inline YAML
inline_kubectl_editor apply     # Apply inline YAML
```

Opens an inline editor for quick Kubernetes manifest editing.

---

## Terraform (`terraform.zsh`)

Helper functions assume this directory structure:

```
stack/
  environments/
    dev.s3.tfbackend
    dev.tfvars
    prod.s3.tfbackend
    prod.tfvars
```

### `tf_init` — Initialize with Backend

```bash
tf_init mystack dev
# Runs: terraform init -reconfigure -backend-config=environments/dev.s3.tfbackend
```

### `tf_plan` — Plan with Variables

```bash
tf_plan mystack dev
# Runs: terraform plan -var-file environments/dev.tfvars
```

### `tf_apply` — Apply with Variables

```bash
tf_apply mystack dev
# Runs: terraform apply -var-file environments/dev.tfvars
```

### `tf_destroy` — Destroy with Variables

```bash
tf_destroy mystack dev
```

### `clean_terraform` — Clean Up

```bash
clean_terraform
# Removes .terraform.lock.hcl and .terraform/ directories
```

---

## Talos (`talos.zsh`)

Functions for managing [Talos Linux](https://www.talos.dev/) clusters.

### `tx` — Switch Context

```bash
tx               # List available contexts
tx my-cluster    # Switch to context
```

### `txf` — Interactive Context Switcher

```bash
txf    # fzf-powered context selection
```

### `tdash` — Dashboard

```bash
tdash              # Dashboard for current node
tdash 10.0.1.5     # Dashboard for specific node
```

### `tdmesg` — Kernel Messages

```bash
tdmesg 10.0.1.5              # Full dmesg
tdmesg 10.0.1.5 "error"     # Grep for errors
```

### `tuptime` — Node Uptime

```bash
tuptime                      # All nodes
tuptime "10.0.1.5 10.0.1.6" # Specific nodes
```

Shows uptime in human-readable format (days, hours, minutes).

### `tlogs` — Node Logs

```bash
tlogs 10.0.1.5              # kubelet logs (default)
tlogs 10.0.1.5 etcd         # etcd logs
```

### `treboot` — Reboot Node

```bash
treboot 10.0.1.5    # Prompts for confirmation before rebooting
```
