---
name: helm-scaffold
description: |
  Scaffold a new Helm chart with production-ready templates and values.
  Use when asked to "create a helm chart", "scaffold helm", or "new chart".
allowed-tools:
  - Bash
  - Write
  - Edit
  - Read
  - AskUserQuestion
---

# Helm Chart Scaffolding

Create production-ready Helm charts.

## Steps

1. Ask for:
   - Chart name
   - App type (web service, worker, cronjob)
   - Whether it needs ingress, HPA, PDB, service account

2. Create the chart structure:
   ```
   <chart-name>/
   ├── Chart.yaml
   ├── values.yaml
   ├── values-dev.yaml
   ├── values-prod.yaml
   ├── templates/
   │   ├── _helpers.tpl
   │   ├── deployment.yaml
   │   ├── service.yaml
   │   ├── serviceaccount.yaml
   │   ├── hpa.yaml
   │   ├── pdb.yaml
   │   ├── ingress.yaml        # if requested
   │   └── tests/
   │       └── test-connection.yaml
   └── .helmignore
   ```

3. Follow these conventions:
   - All resources include standard labels from `_helpers.tpl`
   - Security context: non-root, read-only fs, drop all caps
   - Resource requests/limits templated in values
   - Probes templated with sensible defaults
   - Image tag defaults to `.Chart.AppVersion`
   - `values.yaml` has comments explaining each field

4. Validate with:
   ```bash
   helm lint <chart-name>
   helm template <chart-name> <chart-name>/
   ```
