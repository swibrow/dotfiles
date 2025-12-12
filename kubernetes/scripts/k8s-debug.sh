#!/bin/bash
# Quick launcher for debug pods with various options

set -euo pipefail

# Default values
DEFAULT_NAMESPACE="default"
DEFAULT_IMAGE="nicolaka/netshoot:latest"
POD_NAME="debug-$(date +%s)"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Quick launcher for Kubernetes debug pods.

OPTIONS:
    -n, --namespace NS      Namespace to deploy to (default: $DEFAULT_NAMESPACE)
    -i, --image IMAGE      Image to use (default: $DEFAULT_IMAGE)
    -p, --pod-name NAME    Custom pod name (default: auto-generated)
    -e, --exec             Execute into pod immediately after creation
    -c, --cleanup          Clean up existing debug pods before creating new one
    -l, --list             List existing debug pods
    -h, --help             Show this help message

AVAILABLE DEBUG IMAGES:
    nicolaka/netshoot:latest     - Network troubleshooting
    ubuntu:latest                 - General purpose debugging
    curlimages/curl:latest       - Lightweight curl testing
    busybox:latest               - Minimal debugging
    alpine:latest                - Alpine Linux tools

EXAMPLES:
    $0                           # Create default debug pod
    $0 -e                        # Create and exec into pod
    $0 -i ubuntu:latest -e       # Use Ubuntu and exec
    $0 -c -e                     # Cleanup, create, and exec
    $0 -l                        # List debug pods

EOF
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

cleanup_debug_pods() {
    log_info "Cleaning up existing debug pods..."
    kubectl get pods -n "$1" -l purpose=troubleshooting -o name | xargs -r kubectl delete -n "$1"
    log_success "Cleanup complete"
}

list_debug_pods() {
    log_info "Listing debug pods..."
    kubectl get pods --all-namespaces -l purpose=troubleshooting 2>/dev/null || echo "No debug pods found"
}

create_debug_pod() {
    local namespace=$1
    local image=$2
    local pod_name=$3

    log_info "Creating debug pod: $pod_name"
    log_info "Namespace: $namespace"
    log_info "Image: $image"

    # Create the pod
    kubectl run "$pod_name" \
        --namespace="$namespace" \
        --image="$image" \
        --restart=Always \
        --labels="purpose=troubleshooting,created-by=k8s-debug-script" \
        --limits="memory=512Mi,cpu=500m" \
        --requests="memory=256Mi,cpu=100m" \
        --command -- /bin/sh -c "sleep infinity"

    # Wait for pod to be ready
    log_info "Waiting for pod to be ready..."
    kubectl wait --for=condition=Ready pod/"$pod_name" -n "$namespace" --timeout=60s

    log_success "Debug pod '$pod_name' is ready!"
}

exec_into_pod() {
    local namespace=$1
    local pod_name=$2

    log_info "Executing into pod '$pod_name'..."
    kubectl exec -it -n "$namespace" "$pod_name" -- /bin/sh || kubectl exec -it -n "$namespace" "$pod_name" -- /bin/bash
}

main() {
    local namespace="$DEFAULT_NAMESPACE"
    local image="$DEFAULT_IMAGE"
    local pod_name="$POD_NAME"
    local exec_flag=false
    local cleanup_flag=false
    local list_flag=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--namespace)
                namespace="$2"
                shift 2
                ;;
            -i|--image)
                image="$2"
                shift 2
                ;;
            -p|--pod-name)
                pod_name="$2"
                shift 2
                ;;
            -e|--exec)
                exec_flag=true
                shift
                ;;
            -c|--cleanup)
                cleanup_flag=true
                shift
                ;;
            -l|--list)
                list_flag=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Handle list flag
    if [ "$list_flag" = true ]; then
        list_debug_pods
        exit 0
    fi

    # Handle cleanup
    if [ "$cleanup_flag" = true ]; then
        cleanup_debug_pods "$namespace"
    fi

    # Create the debug pod
    create_debug_pod "$namespace" "$image" "$pod_name"

    # Exec into pod if requested
    if [ "$exec_flag" = true ]; then
        exec_into_pod "$namespace" "$pod_name"
    else
        echo
        log_info "To access the pod, run:"
        echo "    kubectl exec -it -n $namespace $pod_name -- /bin/sh"
        echo
        log_info "To delete the pod when done, run:"
        echo "    kubectl delete pod -n $namespace $pod_name"
    fi
}

main "$@"