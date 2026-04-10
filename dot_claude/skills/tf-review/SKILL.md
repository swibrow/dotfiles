---
name: tf-review
description: |
  Review Terraform code for security, cost, state safety, and best practices.
  Use when asked to "review terraform", "check my tf code", "tf review",
  or when editing .tf files and the user asks for a review.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
paths: "**/*.tf,**/*.tfvars"
---

# Terraform Review

Comprehensive review covering security, cost, state safety, and conventions.

## Review Checklist

### 1. State Safety

- [ ] No resources will be destroyed unexpectedly (check for renames, moved blocks)
- [ ] `prevent_destroy` lifecycle on critical resources (RDS, S3 with data, EFS)
- [ ] State locking enabled (S3 + DynamoDB backend)
- [ ] No hardcoded state paths — uses backend config files
- [ ] No `terraform import` without a plan

### 2. Security

- [ ] No hardcoded secrets, keys, or passwords in `.tf` or `.tfvars`
- [ ] IAM policies follow least privilege — no `*` actions or resources without justification
- [ ] S3 buckets: public access blocked, encryption enabled, versioning on
- [ ] Security groups: no `0.0.0.0/0` ingress without explicit justification
- [ ] RDS/databases: not publicly accessible, encryption at rest enabled
- [ ] KMS keys used for encryption where applicable
- [ ] Secrets in AWS Secrets Manager or SSM Parameter Store, not in variables

### 3. Cost Impact

- [ ] Instance types are appropriate (not oversized)
- [ ] NAT Gateways — are they needed? Consider NAT instances for dev
- [ ] EBS volumes — right type and size? gp3 preferred over gp2
- [ ] RDS — Multi-AZ only in prod? Right instance class?
- [ ] Data transfer — cross-AZ or cross-region transfers flagged
- [ ] Resources that scale — are limits set?
- [ ] Flag any expensive resources being created (ALBs, EIPs, large instances)

### 4. Naming & Conventions

- [ ] Resources use consistent naming: `<project>-<env>-<resource>`
- [ ] Tags: at minimum `Name`, `Environment`, `Project`, `ManagedBy=terraform`
- [ ] Variables have descriptions and types
- [ ] Outputs have descriptions
- [ ] Modules are versioned (not `source = "../"` in prod)

### 5. Structure

- [ ] No mega-files — resources logically separated
- [ ] `locals` used to reduce repetition
- [ ] `for_each` preferred over `count` for named resources
- [ ] Data sources used instead of hardcoded IDs/ARNs
- [ ] Provider versions pinned

## Output Format

Present findings grouped by severity:

**Critical** — Must fix before apply (security holes, state destruction risk)
**Warning** — Should fix (cost waste, missing best practices)
**Info** — Suggestions for improvement

Include the file and line number for each finding.
