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
| `task aws:auth` | `task aws:auth -- myprofile` | Auth with aws-vault |
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
