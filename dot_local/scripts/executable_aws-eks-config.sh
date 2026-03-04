#!/bin/bash
# Dynamic EKS cluster configuration script
# Fetches available clusters and allows interactive selection with fzf

set -euo pipefail

# Default values
DEFAULT_REGION="eu-central-1"
DEFAULT_ROLE_ARN="arn:aws:iam::911453050078:role/dai-dev-eks-access"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Dynamic EKS cluster configuration with interactive selection.

OPTIONS:
    -r, --region REGION     AWS region (default: ${DEFAULT_REGION})
    -R, --role-arn ARN      IAM role ARN to assume for cluster access
    --role-lookup           Interactively select from available IAM roles
    -a, --alias ALIAS       Custom alias for the kubeconfig context
    -l, --list-only         List clusters without configuring
    -h, --help              Show this help message

EXAMPLES:
    $0                          # Interactive mode with defaults
    $0 -r us-west-2             # Specify region
    $0 --role-lookup            # Select role interactively
    $0 -a my-cluster            # Set custom alias
    $0 -l                       # List clusters only

DEPENDENCIES:
    - aws CLI
    - fzf (for interactive selection)
    - jq (for JSON parsing)
EOF
}

check_dependencies() {
    local missing_deps=()

    if ! command -v aws &> /dev/null; then
        missing_deps+=("aws")
    fi

    if ! command -v fzf &> /dev/null; then
        missing_deps+=("fzf")
    fi

    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        log_info "Install missing dependencies and try again"
        exit 1
    fi
}

get_current_region() {
    # Try to get region from AWS CLI config
    local region
    region=$(aws configure get region 2>/dev/null || echo "")

    # If no region configured, use default
    if [ -z "$region" ]; then
        region=$DEFAULT_REGION
    fi

    echo "$region"
}

verify_aws_auth() {
    log_info "Verifying AWS authentication..."

    if ! aws sts get-caller-identity &>/dev/null; then
        log_error "AWS authentication failed. Please authenticate first."
        log_info "Try: aws sso login or aws configure"
        exit 1
    fi

    local identity
    identity=$(aws sts get-caller-identity --output text --query 'Arn' 2>/dev/null || echo "Unknown")
    log_success "Authenticated as: $identity"
}

fetch_clusters() {
    local region=$1

    log_info "Fetching EKS clusters in region: $region"

    local clusters
    clusters=$(aws eks list-clusters --region "$region" --output json 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$clusters" ]; then
        log_error "Failed to fetch clusters from region: $region"
        exit 1
    fi

    local cluster_names
    cluster_names=$(echo "$clusters" | jq -r '.clusters[]?' 2>/dev/null)

    if [ -z "$cluster_names" ]; then
        log_warning "No EKS clusters found in region: $region"
        exit 0
    fi

    echo "$cluster_names"
}

fetch_roles() {
    log_info "Fetching available IAM roles..."

    local roles
    roles=$(aws iam list-roles --output json 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$roles" ]; then
        log_error "Failed to fetch IAM roles"
        exit 1
    fi

    # Filter for EKS-related roles and format them nicely
    local role_info
    role_info=$(echo "$roles" | jq -r '.Roles[] | select(.RoleName | test("eks|EKS|kubernetes|Kubernetes"; "i")) | "\(.Arn) (\(.RoleName))"' 2>/dev/null)

    if [ -z "$role_info" ]; then
        log_warning "No EKS-related roles found, showing all roles..."
        role_info=$(echo "$roles" | jq -r '.Roles[] | "\(.Arn) (\(.RoleName))"' 2>/dev/null | head -20)
    fi

    if [ -z "$role_info" ]; then
        log_warning "No IAM roles found"
        exit 0
    fi

    echo "$role_info"
}

select_role() {
    local roles=$1

    if [ -z "$roles" ]; then
        log_error "No roles available for selection"
        exit 1
    fi

    log_info "Select an IAM role:"

    local selected_role
    selected_role=$(echo "$roles" | fzf \
        --height=15 \
        --border \
        --prompt="Select role: ")

    if [ -z "$selected_role" ]; then
        log_warning "No role selected"
        exit 0
    fi

    # Extract just the ARN (everything before the first space)
    local role_arn
    role_arn=$(echo "$selected_role" | cut -d' ' -f1)

    echo "$role_arn"
}

select_cluster() {
    local clusters=$1
    local region=$2

    if [ -z "$clusters" ]; then
        log_error "No clusters available for selection"
        exit 1
    fi

    log_info "Select an EKS cluster:"

    local selected_cluster
    selected_cluster=$(echo "$clusters" | fzf \
        --height=10 \
        --border \
        --prompt="Select cluster: ")

    if [ -z "$selected_cluster" ]; then
        log_warning "No cluster selected"
        exit 0
    fi

    echo "$selected_cluster"
}

configure_kubeconfig() {
    local cluster_name=$1
    local region=$2
    local role_arn=$3
    local alias_name=$4

    log_info "Configuring kubeconfig for cluster: $cluster_name"

    local cmd="aws eks update-kubeconfig --region $region --name $cluster_name"

    if [ -n "$role_arn" ]; then
        cmd="$cmd --role-arn $role_arn"
    fi

    if [ -n "$alias_name" ]; then
        cmd="$cmd --alias $alias_name"
    fi

    log_info "Running: $cmd"

    if eval "$cmd"; then
        local context_name=${alias_name:-$cluster_name}
        log_success "Kubeconfig updated successfully!"
        log_success "Context: $context_name"

        # Switch to the new context
        kubectl config use-context "$context_name" 2>/dev/null || log_warning "Could not switch to context: $context_name"
    else
        log_error "Failed to update kubeconfig"
        exit 1
    fi
}

main() {
    local region=""
    local role_arn=""
    local alias_name=""
    local list_only=false
    local role_lookup=false

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -r|--region)
                region="$2"
                shift 2
                ;;
            -R|--role-arn)
                role_arn="$2"
                shift 2
                ;;
            --role-lookup)
                role_lookup=true
                shift
                ;;
            -a|--alias)
                alias_name="$2"
                shift 2
                ;;
            -l|--list-only)
                list_only=true
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

    # Set defaults if not provided
    if [ -z "$region" ]; then
        region=$(get_current_region)
    fi

    if [ -z "$role_arn" ]; then
        role_arn=$DEFAULT_ROLE_ARN
    fi

    # Check dependencies
    check_dependencies

    # Verify AWS authentication
    verify_aws_auth

    # Handle role lookup if requested
    if [ "$role_lookup" = true ]; then
        local available_roles
        available_roles=$(fetch_roles)
        role_arn=$(select_role "$available_roles")
        log_success "Selected role: $role_arn"
    fi

    # Fetch available clusters
    local clusters
    clusters=$(fetch_clusters "$region")

    if [ "$list_only" = true ]; then
        log_info "Available clusters in region $region:"
        echo "$clusters"
        exit 0
    fi

    # Select cluster interactively
    local selected_cluster
    selected_cluster=$(select_cluster "$clusters" "$region")

    # Generate alias if not provided
    if [ -z "$alias_name" ]; then
        alias_name="${selected_cluster}-${region}"
    fi

    # Configure kubeconfig
    configure_kubeconfig "$selected_cluster" "$region" "$role_arn" "$alias_name"
}

# Run main function with all arguments
main "$@"