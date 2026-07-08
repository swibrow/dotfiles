# Task Automation

[go-task](https://taskfile.dev/) (invoked as `task`) provides project and global task automation.

## Global Tasks

Run from anywhere with `tg` (alias for `task --global`):

| Task | Description |
|------|-------------|
| `task dotfiles:install` | Install dotfiles |
| `task dotfiles:update` | Pull and apply latest dotfiles |
| `task gh:repo` | Open current repo on GitHub |
| `task gh:actions` | Open GitHub Actions for current repo |

## AWS Tasks

| Task | Usage | Description |
|------|-------|-------------|
| `task aws:list_users` | `task aws:list_users` | List IAM users + access keys |
| `task eks:latestaddons` | `task eks:latestaddons -- 1.29` | Get latest addon versions for EKS |

## Kubernetes Tasks

| Task | Description |
|------|-------------|
| `task kubectl:drain:condoned` | Drain all cordoned nodes |
| `task kubectl:pods:clean` | Delete Succeeded + Failed pods across all namespaces |

## Terraform Tasks

| Task | Description |
|------|-------------|
| `task tf:init` | Init with dynamic S3 backend bucket |
| `task tf:plan` | Plan with sandbox tfvars |

The `tf:init` task auto-resolves the S3 bucket name:

```bash
terraform init -reconfigure \
  -backend-config="bucket=tf-state-$(aws sts get-caller-identity | jq -r .Account)"
```

## GitHub Tasks

Both `gh:repo` and `gh:actions` extract the org/repo from your current working directory path and open the corresponding GitHub page.

```bash
cd ~/dev/dnd-it/my-project
task gh:actions    # Opens https://github.com/dnd-it/my-project/actions
```

## Mise Tasks

Global [mise](https://mise.jdx.dev/) tasks defined in `~/.config/mise/config.toml`, runnable from anywhere with `mise run`:

| Task | Usage | Description |
|------|-------|-------------|
| `keys:top` | `mise run keys:top 30` | Show most-used keys (keyfreq) |
| `keys:reset` | `mise run keys:reset` | Reset keyfreq counts |
| `secret:rm` | `mise run secret:rm NAME` | Remove a secret from the mise config (chezmoi source) and apply |
| `secret:set` | `mise run secret:set NAME` | Age-encrypt a secret into the mise config (chezmoi source) and apply |

### Encrypted Secrets

`secret:set` prompts for the value with hidden input, or reads it from stdin — the value never appears on the command line:

```bash
mise run secret:set KANIDM_ADMIN_PASSWORD                  # prompted, hidden input
keyring-get some-key | mise run secret:set MY_SECRET       # from stdin
```

The value is encrypted with [age](https://age-encryption.org/) to the key at `~/.config/mise/age.txt` and written inline to the `[env]` section of the mise config in the chezmoi source, then applied. The encrypted blob is safe to commit — it can only be decrypted on machines that have the age key, which is not chezmoi-managed.

## Adding Tasks

### Project Tasks

Add a `Taskfile.yaml` in any project directory:

```yaml
version: "3"
tasks:
  build:
    cmds:
      - go build ./...
```

### Global Tasks

Edit `~/.local/share/chezmoi/Taskfile.yaml` (source) or the taskfiles in `dot_taskfiles/`.

Tasks are included via the `includes` directive:

```yaml
includes:
  aws:
    taskfile: ~/.taskfiles/aws/Taskfile.yaml
    optional: true
  kubectl:
    taskfile: ~/.taskfiles/kubectl/Taskfile.yaml
    optional: true
```
