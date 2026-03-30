# Aliases

All aliases are defined in `~/.config/zsh/aliases.zsh`.

## Navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Up one directory |
| `...` | `cd ../..` | Up two directories |
| `....` | `cd ../../..` | Up three directories |
| `.....` | `cd ../../../..` | Up four directories |
| `dev` | `cd ~/git/github.com/swibrow/` | Go to personal dev directory |
| `pitower` | `cd` to pitower repo | Go to pitower project |

## Editors

| Alias | Command | Description |
|-------|---------|-------------|
| `nv` | `nvim .` | Open Neovim in current directory |
| `co` | `code .` | Open VS Code in current directory |
| `cu` | `cursor .` | Open Cursor in current directory |

## Shell

| Alias | Command | Description |
|-------|---------|-------------|
| `zconfig` | `code ~/.zshrc` | Edit shell config |
| `zreload` | `source ~/.zshrc` | Reload shell config |
| `ll` | `ls -al` | Detailed file listing |

## Git

| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Git shorthand |
| `gst` | `git status` | Status |
| `gco` | `git checkout` | Checkout |
| `gcb` | `git checkout -b` | Create and checkout branch |
| `gc` | `git commit` | Commit |
| `gcaa` | `git commit --amend` | Amend last commit |
| `gcaan` | `git commit --amend --no-edit` | Amend without editing message |
| `gp` | `git push` | Push |
| `gpf` | `git push --force-with-lease` | Safe force push |
| `gl` | `git pull` | Pull |
| `gcm` | function | Checkout main or master branch |
| `ghpr` | — | Open/create GitHub PR in browser |

## AWS

| Alias | Command | Description |
|-------|---------|-------------|
| `av` | `aws-vault` | AWS Vault shorthand |
| `avl` | `aws-vault login` | Login to AWS console |
| `ave` | `aws-vault exec` | Execute with AWS credentials |
| `afc` | unset AWS vars | Clear AWS credentials from env |
| `afp` | print profile | Show current AWS profile |

## Kubernetes

| Alias | Command | Description |
|-------|---------|-------------|
| `k` | `kubectl` | kubectl shorthand |
| `kx` | `kubectx` | Switch k8s context |
| `kns` | `kubens` | Switch namespace |
| `kt` | `kubetail` | Tail pod logs |
| `kgpa` | `kubectl get pods -A` | All pods, all namespaces |
| `kgp` | `kubectl get pods` | Pods in current namespace |
| `kgs` | `kubectl get svc` | Services |
| `kgd` | `kubectl get deploy` | Deployments |
| `kgn` | `kubectl get nodes` | Nodes |
| `kgi` | `kubectl get ingress` | Ingresses |
| `kdp` | `kubectl describe pod` | Describe pod |
| `kds` | `kubectl describe svc` | Describe service |
| `kdn` | `kubectl describe node` | Describe node |
| `kdrain` | `kubectl drain` with flags | Drain node safely |

## Infrastructure

| Alias | Command | Description |
|-------|---------|-------------|
| `tf` | `terraform` | Terraform shorthand |
| `tffmt` | `terraform fmt -recursive` | Format all TF files |
| `t` | `talosctl` | Talos control shorthand |

## Fuzzy Finding

| Alias | Command | Description |
|-------|---------|-------------|
| `f` | `fzf` | Basic fuzzy find |
| `ff` | fzf with preview | Fuzzy find with file preview |
| `ft` | fzf file tree | Fuzzy find in tree view |
| `y` | `yazi` | Terminal file manager |

## Utilities

| Alias | Command | Description |
|-------|---------|-------------|
| `bd` | base64 decode | Decode base64 string |
| `b` | base64 encode | Encode to base64 |
| `tg` | `task --global` | Run global tasks |
| `tm` | `task-master` | Task master shorthand |

## Worktrunk (Git Worktrees)

| Alias | Command | Description |
|-------|---------|-------------|
| `wts` | `wt switch` | Switch worktree |
| `wtc` | `wt create` | Create worktree |
| `wtl` | `wt list` | List worktrees |
| `wtr` | `wt remove` | Remove worktree |
| `wtm` | `wt merge` | Merge worktree |
| `wsc` | `wt switch --create -x claude` | Create worktree and open Claude |
