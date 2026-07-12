# Terraform

## Shell Functions

Helper functions expect this directory structure per stack:

```
stack/
  environments/
    dev.s3.tfbackend
    dev.tfvars
    prod.s3.tfbackend
    prod.tfvars
```

### Initialize

```bash
tf_init mystack dev
```

Runs `terraform init -reconfigure -backend-config=environments/dev.s3.tfbackend`.

### Plan

```bash
tf_plan mystack dev
```

Runs `terraform plan -var-file environments/dev.tfvars`.

### Apply

```bash
tf_apply mystack dev
```

### Destroy

```bash
tf_destroy mystack dev
```

### Clean Up

```bash
clean_terraform
```

Removes `.terraform.lock.hcl` and `.terraform/` directories from the current tree.

## Aliases

| Alias | Command |
|-------|---------|
| `tf` | `terraform` |
| `tffmt` | `terraform fmt -recursive` |

## Provider Cache

Terraform providers are cached globally to avoid re-downloading:

```bash
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
```

## Prompt Integration

Starship shows the current Terraform workspace and version in the prompt when you're in a directory with `.tf` files.
