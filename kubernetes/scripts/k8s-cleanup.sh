#!/bin/bash
# Clean up test and debug resources in Kubernetes

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Clean up test and debug resources in Kubernetes.

OPTIONS:
    -n, --namespace NS     Target namespace (default: all namespaces)
    -a, --all             Clean up all test resources
    -d, --debug-pods      Clean up debug pods only
    -j, --jobs            Clean up completed/failed jobs
    -t, --test-pods       Clean up test pods
    -f, --failed          Clean up failed pods
    --dry-run             Show what would be deleted without deleting
    -h, --help            Show this help message

EXAMPLES:
    $0 -a                 # Clean up all test resources
    $0 -d                 # Clean up debug pods only
    $0 -j -n default      # Clean up jobs in default namespace
    $0 --dry-run -a       # Preview cleanup without deleting

EOF
}

cleanup_debug_pods() {
    local namespace=$1
    local dry_run=$2
    local ns_flag=""

    if [ "$namespace" != "all" ]; then
        ns_flag="-n $namespace"
    else
        ns_flag="--all-namespaces"
    fi

    log_info "Cleaning up debug pods..."

    if [ "$dry_run" = true ]; then
        kubectl get pods $ns_flag -l purpose=troubleshooting 2>/dev/null || echo "No debug pods found"
    else
        kubectl delete pods $ns_flag -l purpose=troubleshooting 2>/dev/null || log_info "No debug pods to delete"
    fi
}

cleanup_test_pods() {
    local namespace=$1
    local dry_run=$2
    local ns_flag=""

    if [ "$namespace" != "all" ]; then
        ns_flag="-n $namespace"
    else
        ns_flag="--all-namespaces"
    fi

    log_info "Cleaning up test pods..."

    if [ "$dry_run" = true ]; then
        kubectl get pods $ns_flag -l 'app in (curl-test, network-test, stress-test, resource-monitor)' 2>/dev/null || echo "No test pods found"
    else
        kubectl delete pods $ns_flag -l 'app in (curl-test, network-test, stress-test, resource-monitor)' 2>/dev/null || log_info "No test pods to delete"
    fi
}

cleanup_jobs() {
    local namespace=$1
    local dry_run=$2
    local ns_flag=""

    if [ "$namespace" != "all" ]; then
        ns_flag="-n $namespace"
    else
        ns_flag="--all-namespaces"
    fi

    log_info "Cleaning up completed and failed jobs..."

    # Get completed jobs
    if [ "$dry_run" = true ]; then
        log_info "Jobs that would be deleted:"
        kubectl get jobs $ns_flag --field-selector status.successful=1 2>/dev/null || echo "No completed jobs"
        kubectl get jobs $ns_flag --field-selector status.successful=0 2>/dev/null || echo "No failed jobs"
    else
        kubectl delete jobs $ns_flag --field-selector status.successful=1 2>/dev/null || log_info "No completed jobs to delete"
        kubectl delete jobs $ns_flag --field-selector status.successful=0 2>/dev/null || log_info "No failed jobs to delete"
    fi
}

cleanup_failed_pods() {
    local namespace=$1
    local dry_run=$2
    local ns_flag=""

    if [ "$namespace" != "all" ]; then
        ns_flag="-n $namespace"
    else
        ns_flag="--all-namespaces"
    fi

    log_info "Cleaning up failed pods..."

    if [ "$dry_run" = true ]; then
        kubectl get pods $ns_flag --field-selector=status.phase=Failed 2>/dev/null || echo "No failed pods found"
        kubectl get pods $ns_flag --field-selector=status.phase=Succeeded 2>/dev/null || echo "No succeeded pods found"
    else
        kubectl delete pods $ns_flag --field-selector=status.phase=Failed 2>/dev/null || log_info "No failed pods to delete"
        kubectl delete pods $ns_flag --field-selector=status.phase=Succeeded 2>/dev/null || log_info "No succeeded pods to delete"
    fi
}

main() {
    local namespace="all"
    local cleanup_all=false
    local cleanup_debug=false
    local cleanup_jobs=false
    local cleanup_test=false
    local cleanup_failed=false
    local dry_run=false

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--namespace)
                namespace="$2"
                shift 2
                ;;
            -a|--all)
                cleanup_all=true
                shift
                ;;
            -d|--debug-pods)
                cleanup_debug=true
                shift
                ;;
            -j|--jobs)
                cleanup_jobs=true
                shift
                ;;
            -t|--test-pods)
                cleanup_test=true
                shift
                ;;
            -f|--failed)
                cleanup_failed=true
                shift
                ;;
            --dry-run)
                dry_run=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                log_warning "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # If no specific cleanup flag is set, show usage
    if [ "$cleanup_all" = false ] && [ "$cleanup_debug" = false ] && \
       [ "$cleanup_jobs" = false ] && [ "$cleanup_test" = false ] && \
       [ "$cleanup_failed" = false ]; then
        log_warning "No cleanup option specified"
        show_usage
        exit 1
    fi

    if [ "$dry_run" = true ]; then
        log_warning "DRY RUN MODE - Nothing will be deleted"
        echo
    fi

    # Perform cleanup based on flags
    if [ "$cleanup_all" = true ] || [ "$cleanup_debug" = true ]; then
        cleanup_debug_pods "$namespace" "$dry_run"
    fi

    if [ "$cleanup_all" = true ] || [ "$cleanup_test" = true ]; then
        cleanup_test_pods "$namespace" "$dry_run"
    fi

    if [ "$cleanup_all" = true ] || [ "$cleanup_jobs" = true ]; then
        cleanup_jobs "$namespace" "$dry_run"
    fi

    if [ "$cleanup_all" = true ] || [ "$cleanup_failed" = true ]; then
        cleanup_failed_pods "$namespace" "$dry_run"
    fi

    if [ "$dry_run" = false ]; then
        log_success "Cleanup completed!"
    else
        echo
        log_info "Run without --dry-run to perform actual cleanup"
    fi
}

main "$@"