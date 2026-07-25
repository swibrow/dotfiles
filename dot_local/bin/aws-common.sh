# Shared helpers for the aws-* scripts in this directory. Sourced, not run directly.
# Callers must set DEFAULT_REGION before calling get_current_region.

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
    local region
    region=$(aws configure get region 2>/dev/null || echo "")

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
