# AWS

## Profile Switching

### `af` — Interactive Profile Switcher

The primary way to switch AWS profiles:

```bash
af
```

1. Presents all AWS profiles via fzf
2. Exports `AWS_PROFILE`
3. Checks if the session is valid (`sts get-caller-identity`)
4. If expired, triggers `aws sso login`
5. Displays account info on success

### Quick Aliases

| Alias | Action |
|-------|--------|
| `afc` | Clear all AWS env vars |
| `afp` | Print current AWS profile |

## CLI Aliases

Custom AWS CLI aliases are defined in `~/.aws/cli/alias`:

### Identity

```bash
aws whoami      # Quick: sts get-caller-identity
aws identity    # Full: identity in table format
```

### Profiles

Parsed from `~/.aws/config`, showing SSO account and role alongside each name:

```bash
aws profile-list             # name / sso_account_id / sso_role_name, aligned
aws profile-pick [query]     # same list through fzf, prints the name only
export AWS_PROFILE=$(aws profile-pick)
```

Use `af` to switch and handle SSO login - an `aws` alias runs in a subprocess and
cannot change the current shell.

### EKS

```bash
aws eks-list [region]                     # List clusters
aws eks-update [region]                   # Pick a cluster (fzf) and update kubeconfig

EKS_ROLE_ARN=$(aws role-pick eks) aws eks-update   # cross-account: kubectl assumes that role
```

## Role Assumption

Shell functions (`dot_config/zsh/functions/general.zsh`), not CLI aliases: the
credentials have to land in the current shell, and `aws` aliases run in a subprocess.

```bash
aws-assume                          # pick a role with fzf, export its credentials
aws-assume arn:aws:iam::123:role/X  # or pass the ARN
aws-unassume                        # drop the credentials, restore AWS_PROFILE
```

## Max Pods Calculator

```bash
max-pods-calculator --instance-type m5.large --cni-version 1.12.0
```

Calculates the maximum number of pods for an EKS node based on instance type, CNI version, and prefix delegation settings.
