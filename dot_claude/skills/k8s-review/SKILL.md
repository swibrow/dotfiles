---
name: k8s-review
description: |
  Review Kubernetes manifests for security, reliability, and best practices.
  Use when asked to "review k8s manifests", "check my yaml", "review deployment",
  or when editing Kubernetes YAML files.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash
paths: "**/*.yaml,**/*.yml"
---

# Kubernetes Manifest Review

Review Kubernetes manifests for production readiness.

## Review Checklist

### 1. Security

- [ ] No containers running as root (`runAsNonRoot: true`)
- [ ] Read-only root filesystem where possible
- [ ] No privileged containers unless justified
- [ ] Security context set (drop all capabilities, add only needed)
- [ ] No `hostNetwork`, `hostPID`, `hostIPC` unless justified
- [ ] Service accounts — not using `default`, automountServiceAccountToken disabled if unused
- [ ] Network policies exist to restrict traffic
- [ ] Secrets not hardcoded — use External Secrets, Sealed Secrets, or CSI driver
- [ ] Image tags are pinned (no `latest`)

### 2. Reliability

- [ ] Resource requests AND limits set for all containers
- [ ] Liveness and readiness probes configured
- [ ] `startupProbe` for slow-starting containers
- [ ] Pod Disruption Budget (PDB) defined
- [ ] Topology spread constraints or anti-affinity for HA
- [ ] Replica count > 1 for production workloads
- [ ] `terminationGracePeriodSeconds` appropriate for the workload
- [ ] `preStop` hook if the app needs graceful shutdown time

### 3. Observability

- [ ] Labels: `app.kubernetes.io/name`, `app.kubernetes.io/version`, `app.kubernetes.io/component`
- [ ] Annotations for monitoring (prometheus scrape config if applicable)
- [ ] Log format is structured (JSON preferred)

### 4. Networking

- [ ] Services use correct type (ClusterIP default, LoadBalancer only when needed)
- [ ] Ingress has TLS configured
- [ ] Port names follow convention (`http`, `https`, `grpc`, `metrics`)

### 5. Resource Sizing

- [ ] CPU requests are realistic (not `1m` or `10`)
- [ ] Memory limits match actual usage (check OOMKills)
- [ ] Ephemeral storage limits set if applicable
- [ ] HPA configured with appropriate metrics and bounds

## Output Format

Group findings by severity: **Critical**, **Warning**, **Info**.
Include file path and resource name for each finding.
