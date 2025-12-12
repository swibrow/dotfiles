# Kubernetes Utilities

A collection of useful Kubernetes manifests, scripts, and utilities for testing and debugging.

## Directory Structure

```
kubernetes/
├── deployments/          # Ready-to-use deployment templates
├── manifests/           # Kubernetes manifests organized by purpose
│   ├── debug/          # Debugging tools and pods
│   ├── testing/        # Test workloads and stress tests
│   └── monitoring/     # Monitoring and observability tools
├── scripts/            # Helper scripts for common tasks
└── utils/             # Utility configurations and tools
```

## Quick Usage

### Deploy a debug pod
```bash
kubectl apply -f ~/dotfiles/kubernetes/manifests/debug/debug-pod.yaml
kubectl exec -it debug-pod -- bash
```

### Run network test
```bash
kubectl apply -f ~/dotfiles/kubernetes/manifests/testing/network-test.yaml
```

### Deploy resource stress test
```bash
kubectl apply -f ~/dotfiles/kubernetes/manifests/testing/stress-test.yaml
```

## Available Tools

### Debug Manifests
- `debug-pod.yaml` - Alpine-based debug pod with network tools
- `ubuntu-debug.yaml` - Ubuntu debug pod with comprehensive tools
- `network-debug.yaml` - Network debugging specialist pod

### Testing Manifests
- `network-test.yaml` - Network connectivity tester
- `stress-test.yaml` - CPU/Memory stress testing
- `storage-test.yaml` - Storage performance testing
- `api-load-test.yaml` - API server load testing

### Scripts
- `k8s-debug.sh` - Quick debug pod launcher
- `k8s-cleanup.sh` - Clean up test resources
- `k8s-network-test.sh` - Automated network testing