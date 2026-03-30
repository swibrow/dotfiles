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
| `av` | `aws-vault` |
| `avl` | `aws-vault login` (open console) |
| `ave` | `aws-vault exec` (run command with creds) |
| `afc` | Clear all AWS env vars |
| `afp` | Print current AWS profile |

## AWS Vault

Credentials are managed via [aws-vault](https://github.com/99designs/aws-vault) with the macOS keychain backend:

```bash
export AWS_VAULT_BACKEND=keychain
```

## CLI Aliases

Custom AWS CLI aliases are defined in `~/.aws/cli/alias`:

### Identity

```bash
aws whoami      # Quick: sts get-caller-identity
aws identity    # Full: identity in table format
```

### Profile Switching

```bash
aws dev-profile       # Set AWS_PROFILE=dev
aws prod-profile      # Set AWS_PROFILE=prod
aws default-profile   # Unset AWS_PROFILE
```

### EKS

```bash
aws eks-list                              # List clusters in current region
aws eks-update <cluster> <region> <role>  # Update kubeconfig
aws eks-config                            # Interactive configuration script
```

### Role Assumption

```bash
aws assume-role <role>   # Assume an IAM role
aws dai-dev              # Shortcut: assume dev role
aws dai-dev-eks          # Shortcut: assume dev EKS role
aws clear-creds          # Clear cached credentials
```

## EKS Configuration Script

The `aws-eks-config.sh` script provides interactive EKS cluster setup:

```bash
aws-eks-config.sh
aws-eks-config.sh -r eu-west-1                    # Specify region
aws-eks-config.sh -R arn:aws:iam::123:role/Admin   # With role
aws-eks-config.sh --role-lookup                     # Interactive role picker
aws-eks-config.sh -a my-cluster-alias              # Custom context name
aws-eks-config.sh -l                               # List clusters only
```

Features:

- Interactive cluster selection with fzf
- Region configuration
- IAM role assumption
- Kubeconfig context aliasing
- Auth verification after configuration

## IAM User Audit

```bash
task aws:list_users
```

Lists all IAM users with their access key IDs and last-used dates.

## Max Pods Calculator

```bash
max-pods-calculator.sh --instance-type m5.large --cni-version 1.12.0
```

Calculates the maximum number of pods for an EKS node based on instance type, CNI version, and prefix delegation settings.
