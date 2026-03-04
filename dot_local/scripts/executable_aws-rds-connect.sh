#!/bin/bash
# Interactive RDS database connection tool
# Uses fzf to select RDS instance and Secrets Manager secret for credentials

set -euo pipefail

# Default values
DEFAULT_REGION="eu-central-1"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

log_detail() {
    echo -e "${CYAN}  →${NC} $1" >&2
}

show_usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Interactive RDS database connection with fzf selection.

Workflow:
  1. Lists all RDS instances in the region
  2. Select an RDS instance with fzf
  3. Lists all Secrets Manager secrets (filtered for DB-related)
  4. Select a secret containing database credentials
  5. Connects to the database using the retrieved credentials

OPTIONS:
    -r, --region REGION     AWS region (default: ${DEFAULT_REGION})
    -c, --client CLIENT     Database client to use (pgcli, mycli, mongosh)
                            Auto-detected from engine if not specified
    -l, --list-only         List RDS instances without connecting
    -s, --show-secret       Show secret contents (for debugging)
    -o, --output            Output connection string instead of connecting
    -p, --port-forward      Use SSM port forwarding (for private instances)
    -h, --help              Show this help message

EXAMPLES:
    $0                          # Interactive mode with defaults
    $0 -r us-west-2             # Specify region
    $0 -l                       # List RDS instances only
    $0 -o                       # Output connection string
    $0 -c pgcli                 # Force pgcli client

SUPPORTED ENGINES:
    - PostgreSQL (pgcli)
    - MySQL/MariaDB (mycli)
    - MongoDB (mongosh)

DEPENDENCIES:
    - aws CLI
    - fzf (for interactive selection)
    - jq (for JSON parsing)
    - Database client (psql, mysql, or mongosh)
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

fetch_rds_instances() {
    local region=$1

    log_info "Fetching RDS instances in region: $region"

    local instances
    instances=$(aws rds describe-db-instances --region "$region" --output json 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$instances" ]; then
        log_error "Failed to fetch RDS instances from region: $region"
        exit 1
    fi

    # Format: identifier | engine | status | endpoint
    local instance_list
    instance_list=$(echo "$instances" | jq -r '
        .DBInstances[] |
        "\(.DBInstanceIdentifier)\t\(.Engine)\t\(.DBInstanceStatus)\t\(.Endpoint.Address // "N/A")\t\(.Endpoint.Port // "N/A")"
    ' 2>/dev/null)

    if [ -z "$instance_list" ]; then
        log_warning "No RDS instances found in region: $region"
        exit 0
    fi

    echo "$instance_list"
}

fetch_rds_clusters() {
    local region=$1

    log_info "Fetching RDS Aurora clusters in region: $region"

    local clusters
    clusters=$(aws rds describe-db-clusters --region "$region" --output json 2>/dev/null || echo '{"DBClusters":[]}')

    # Format: identifier | engine | status | endpoint
    local cluster_list
    cluster_list=$(echo "$clusters" | jq -r '
        .DBClusters[] |
        "\(.DBClusterIdentifier)\t\(.Engine)\t\(.Status)\t\(.Endpoint // "N/A")\t\(.Port // "N/A")"
    ' 2>/dev/null)

    echo "$cluster_list"
}

select_rds_instance() {
    local instances=$1
    local clusters=$2
    local region=$3

    # Combine instances and clusters
    local all_databases=""

    if [ -n "$instances" ]; then
        all_databases="$instances"
    fi

    if [ -n "$clusters" ]; then
        if [ -n "$all_databases" ]; then
            all_databases="${all_databases}"$'\n'"${clusters}"
        else
            all_databases="$clusters"
        fi
    fi

    if [ -z "$all_databases" ]; then
        log_error "No RDS instances or clusters available"
        exit 1
    fi

    log_info "Select an RDS instance/cluster:"

    local header="IDENTIFIER\tENGINE\tSTATUS\tENDPOINT\tPORT"
    local selected
    selected=$(echo -e "$header\n$all_databases" | column -t -s $'\t' | fzf \
        --height=20 \
        --border \
        --header-lines=1 \
        --prompt="Select database: " \
        --preview-window=hidden)

    if [ -z "$selected" ]; then
        log_warning "No instance selected"
        exit 0
    fi

    # Extract the identifier (first column)
    local identifier
    identifier=$(echo "$selected" | awk '{print $1}')

    echo "$identifier"
}

get_rds_details() {
    local identifier=$1
    local region=$2

    # Try to get instance details first
    local details
    details=$(aws rds describe-db-instances \
        --region "$region" \
        --db-instance-identifier "$identifier" \
        --output json 2>/dev/null || echo "")

    if [ -n "$details" ] && [ "$(echo "$details" | jq '.DBInstances | length')" -gt 0 ]; then
        echo "$details" | jq -r '.DBInstances[0] | {
            endpoint: .Endpoint.Address,
            port: .Endpoint.Port,
            engine: .Engine,
            database: .DBName
        }'
        return
    fi

    # Try cluster
    details=$(aws rds describe-db-clusters \
        --region "$region" \
        --db-cluster-identifier "$identifier" \
        --output json 2>/dev/null || echo "")

    if [ -n "$details" ] && [ "$(echo "$details" | jq '.DBClusters | length')" -gt 0 ]; then
        echo "$details" | jq -r '.DBClusters[0] | {
            endpoint: .Endpoint,
            port: .Port,
            engine: .Engine,
            database: .DatabaseName
        }'
        return
    fi

    log_error "Could not fetch details for: $identifier"
    exit 1
}

fetch_secrets() {
    local region=$1
    local db_identifier=$2

    log_info "Fetching secrets from Secrets Manager..."

    local secrets
    secrets=$(aws secretsmanager list-secrets --region "$region" --output json 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$secrets" ]; then
        log_error "Failed to fetch secrets from region: $region"
        exit 1
    fi

    # Filter for database-related secrets and format nicely
    # Look for common patterns: rds, db, database, postgres, mysql, the db identifier
    local secret_list
    secret_list=$(echo "$secrets" | jq -r --arg db "$db_identifier" '
        .SecretList[] |
        select(
            (.Name | test("rds|db|database|postgres|mysql|aurora|mongo|password|cred"; "i")) or
            (.Name | test($db; "i")) or
            (.Description // "" | test("rds|db|database"; "i"))
        ) |
        "\(.Name)\t\(.Description // "No description")"
    ' 2>/dev/null)

    # If no filtered results, show all secrets
    if [ -z "$secret_list" ]; then
        log_warning "No database-related secrets found, showing all secrets..."
        secret_list=$(echo "$secrets" | jq -r '
            .SecretList[] |
            "\(.Name)\t\(.Description // "No description")"
        ' 2>/dev/null)
    fi

    if [ -z "$secret_list" ]; then
        log_warning "No secrets found in region: $region"
        exit 0
    fi

    echo "$secret_list"
}

select_secret() {
    local secrets=$1

    if [ -z "$secrets" ]; then
        log_error "No secrets available for selection"
        exit 1
    fi

    log_info "Select a secret containing database credentials:"

    local header="SECRET_NAME\tDESCRIPTION"
    local selected
    selected=$(echo -e "$header\n$secrets" | column -t -s $'\t' | fzf \
        --height=20 \
        --border \
        --header-lines=1 \
        --prompt="Select secret: " \
        --preview-window=hidden)

    if [ -z "$selected" ]; then
        log_warning "No secret selected"
        exit 0
    fi

    # Extract the secret name (first column)
    local secret_name
    secret_name=$(echo "$selected" | awk '{print $1}')

    echo "$secret_name"
}

get_secret_value() {
    local secret_name=$1
    local region=$2

    log_info "Retrieving secret: $secret_name"

    local secret_value
    secret_value=$(aws secretsmanager get-secret-value \
        --region "$region" \
        --secret-id "$secret_name" \
        --output json 2>/dev/null)

    if [ $? -ne 0 ] || [ -z "$secret_value" ]; then
        log_error "Failed to retrieve secret: $secret_name"
        exit 1
    fi

    # Extract the secret string (could be JSON or plain text)
    local secret_string
    secret_string=$(echo "$secret_value" | jq -r '.SecretString' 2>/dev/null)

    echo "$secret_string"
}

select_secret_key() {
    local secret_string=$1
    local field_type=$2  # username, password, host, port, database

    local keys_with_values
    keys_with_values=$(echo "$secret_string" | jq -r 'to_entries[] | "\(.key)\t\(.value)"' 2>/dev/null)

    if [ -z "$keys_with_values" ]; then
        return 1
    fi

    log_info "Select the key for $field_type:"

    local header="KEY\tVALUE"
    local selected
    selected=$(echo -e "$header\n$keys_with_values" | column -t -s $'\t' | fzf \
        --height=15 \
        --border \
        --header-lines=1 \
        --prompt="Select $field_type key: ")

    if [ -z "$selected" ]; then
        return 1
    fi

    # Extract the key name (first column)
    local key_name
    key_name=$(echo "$selected" | awk '{print $1}')

    # Get the value for that key
    echo "$secret_string" | jq -r --arg key "$key_name" '.[$key]' 2>/dev/null
}

parse_credentials() {
    local secret_string=$1

    # Try to parse as JSON first (common format for RDS secrets)
    if ! echo "$secret_string" | jq -e . &>/dev/null; then
        log_error "Secret is not in JSON format. Cannot parse credentials."
        log_info "Secret value: $secret_string"
        exit 1
    fi

    # Show available keys
    log_info "Secret keys found:"
    echo "$secret_string" | jq -r 'keys[]' | while read -r key; do
        log_detail "$key"
    done

    # JSON format - try common field names first
    local username password host port database

    # Try common username patterns
    username=$(echo "$secret_string" | jq -r '
        .username // .user // .Username // .USER //
        .POSTGRES_USER // .postgres_user // .DB_USER // .db_user //
        .MYSQL_USER // .mysql_user // empty
    ' 2>/dev/null)

    # Try common password patterns
    password=$(echo "$secret_string" | jq -r '
        .password // .pass // .Password // .PASS //
        .POSTGRES_PASSWORD // .postgres_password // .DB_PASSWORD // .db_password //
        .MYSQL_PASSWORD // .mysql_password // .PASSWORD // empty
    ' 2>/dev/null)

    # Try common host patterns
    host=$(echo "$secret_string" | jq -r '
        .host // .hostname // .Host // .endpoint // .Endpoint //
        .POSTGRES_HOST // .postgres_host // .DB_HOST // .db_host //
        .MYSQL_HOST // .mysql_host // .HOST // empty
    ' 2>/dev/null)

    # Try common port patterns
    port=$(echo "$secret_string" | jq -r '
        .port // .Port // .PORT //
        .POSTGRES_PORT // .postgres_port // .DB_PORT // .db_port //
        .MYSQL_PORT // .mysql_port // empty
    ' 2>/dev/null)

    # Try common database patterns
    database=$(echo "$secret_string" | jq -r '
        .database // .dbname // .db // .Database // .DB //
        .POSTGRES_DB // .postgres_db // .DB_NAME // .db_name //
        .MYSQL_DATABASE // .mysql_database // .name // empty
    ' 2>/dev/null)

    # If username not found, use fzf to select
    if [ -z "$username" ] || [ "$username" = "null" ]; then
        log_warning "Could not auto-detect username key"
        username=$(select_secret_key "$secret_string" "username") || username=""
    fi

    # If password not found, use fzf to select
    if [ -z "$password" ] || [ "$password" = "null" ]; then
        log_warning "Could not auto-detect password key"
        password=$(select_secret_key "$secret_string" "password") || password=""
    fi

    # If host not found, use fzf to select (optional - can use RDS endpoint)
    if [ -z "$host" ] || [ "$host" = "null" ]; then
        log_info "No host key found in secret (will use RDS endpoint)"
        host=""
    fi

    # If port not found, use fzf to select (optional - can use RDS port)
    if [ -z "$port" ] || [ "$port" = "null" ]; then
        log_info "No port key found in secret (will use RDS port)"
        port=""
    fi

    # If database not found, use fzf to select (optional)
    if [ -z "$database" ] || [ "$database" = "null" ]; then
        log_info "No database key found in secret"
        # Ask if user wants to select a database key
        local db_keys
        db_keys=$(echo "$secret_string" | jq -r 'keys[]' | grep -iE 'db|database|name' || true)
        if [ -n "$db_keys" ]; then
            database=$(select_secret_key "$secret_string" "database") || database=""
        else
            database=""
        fi
    fi

    echo "{\"username\":\"$username\",\"password\":\"$password\",\"host\":\"$host\",\"port\":\"$port\",\"database\":\"$database\"}"
}

detect_client() {
    local engine=$1

    case "$engine" in
        postgres*|aurora-postgres*)
            echo "pgcli"
            ;;
        mysql*|mariadb*|aurora-mysql*)
            echo "mycli"
            ;;
        docdb*|mongo*)
            echo "mongosh"
            ;;
        *)
            log_warning "Unknown engine: $engine, defaulting to pgcli"
            echo "pgcli"
            ;;
    esac
}

check_client() {
    local client=$1

    if ! command -v "$client" &> /dev/null; then
        log_error "Database client '$client' not found"
        log_info "Install it with:"
        case "$client" in
            pgcli)
                log_detail "brew install pgcli"
                ;;
            mycli)
                log_detail "brew install mycli"
                ;;
            mongosh)
                log_detail "brew install mongosh"
                ;;
        esac
        exit 1
    fi
}

build_connection_string() {
    local client=$1
    local host=$2
    local port=$3
    local username=$4
    local password=$5
    local database=$6

    case "$client" in
        pgcli)
            # PostgreSQL connection string
            echo "postgresql://${username}:${password}@${host}:${port}/${database}"
            ;;
        mycli)
            # MySQL connection string
            echo "mysql://${username}:${password}@${host}:${port}/${database}"
            ;;
        mongosh)
            # MongoDB connection string
            echo "mongodb://${username}:${password}@${host}:${port}/${database}"
            ;;
    esac
}

connect_to_database() {
    local client=$1
    local host=$2
    local port=$3
    local username=$4
    local password=$5
    local database=$6

    log_info "Connecting to database..."
    log_detail "Host: $host"
    log_detail "Port: $port"
    log_detail "User: $username"
    log_detail "Database: $database"

    case "$client" in
        pgcli)
            PGPASSWORD="$password" pgcli -h "$host" -p "$port" -U "$username" -d "$database"
            ;;
        mycli)
            mycli -h "$host" -P "$port" -u "$username" -p"$password" "$database"
            ;;
        mongosh)
            mongosh "mongodb://${username}:${password}@${host}:${port}/${database}"
            ;;
    esac
}

main() {
    local region=""
    local client=""
    local list_only=false
    local show_secret=false
    local output_only=false
    local port_forward=false

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -r|--region)
                region="$2"
                shift 2
                ;;
            -c|--client)
                client="$2"
                shift 2
                ;;
            -l|--list-only)
                list_only=true
                shift
                ;;
            -s|--show-secret)
                show_secret=true
                shift
                ;;
            -o|--output)
                output_only=true
                shift
                ;;
            -p|--port-forward)
                port_forward=true
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

    # Check dependencies
    check_dependencies

    # Verify AWS authentication
    verify_aws_auth

    # Fetch RDS instances and clusters
    local instances clusters
    instances=$(fetch_rds_instances "$region")
    clusters=$(fetch_rds_clusters "$region")

    if [ "$list_only" = true ]; then
        log_info "Available RDS instances/clusters in region $region:"
        echo -e "IDENTIFIER\tENGINE\tSTATUS\tENDPOINT\tPORT"
        if [ -n "$instances" ]; then
            echo "$instances"
        fi
        if [ -n "$clusters" ]; then
            echo "$clusters"
        fi
        exit 0
    fi

    # Select RDS instance
    local selected_db
    selected_db=$(select_rds_instance "$instances" "$clusters" "$region")
    log_success "Selected database: $selected_db"

    # Get RDS details
    local db_details
    db_details=$(get_rds_details "$selected_db" "$region")

    local db_endpoint db_port db_engine db_name
    db_endpoint=$(echo "$db_details" | jq -r '.endpoint')
    db_port=$(echo "$db_details" | jq -r '.port')
    db_engine=$(echo "$db_details" | jq -r '.engine')
    db_name=$(echo "$db_details" | jq -r '.database // "postgres"')

    log_detail "Endpoint: $db_endpoint"
    log_detail "Port: $db_port"
    log_detail "Engine: $db_engine"

    # Detect or use specified client
    if [ -z "$client" ]; then
        client=$(detect_client "$db_engine")
    fi
    log_detail "Client: $client"

    # Check if client is available
    check_client "$client"

    # Fetch and select secret
    local secrets
    secrets=$(fetch_secrets "$region" "$selected_db")

    local selected_secret
    selected_secret=$(select_secret "$secrets")
    log_success "Selected secret: $selected_secret"

    # Get secret value
    local secret_value
    secret_value=$(get_secret_value "$selected_secret" "$region")

    if [ "$show_secret" = true ]; then
        log_info "Secret contents:"
        echo "$secret_value" | jq .
    fi

    # Parse credentials
    local credentials
    credentials=$(parse_credentials "$secret_value")

    local cred_username cred_password cred_host cred_port cred_database
    cred_username=$(echo "$credentials" | jq -r '.username')
    cred_password=$(echo "$credentials" | jq -r '.password')
    cred_host=$(echo "$credentials" | jq -r '.host')
    cred_port=$(echo "$credentials" | jq -r '.port')
    cred_database=$(echo "$credentials" | jq -r '.database')

    # Use RDS endpoint if secret doesn't have host
    if [ -z "$cred_host" ] || [ "$cred_host" = "null" ]; then
        cred_host="$db_endpoint"
    fi

    # Use RDS port if secret doesn't have port
    if [ -z "$cred_port" ] || [ "$cred_port" = "null" ]; then
        cred_port="$db_port"
    fi

    # Use detected database name if secret doesn't have it
    if [ -z "$cred_database" ] || [ "$cred_database" = "null" ]; then
        cred_database="$db_name"
    fi

    # Validate we have required credentials
    if [ -z "$cred_username" ] || [ "$cred_username" = "null" ]; then
        log_error "Could not find username in secret"
        exit 1
    fi

    if [ -z "$cred_password" ] || [ "$cred_password" = "null" ]; then
        log_error "Could not find password in secret"
        exit 1
    fi

    # Output connection string or connect
    if [ "$output_only" = true ]; then
        log_info "Connection string:"
        build_connection_string "$client" "$cred_host" "$cred_port" "$cred_username" "$cred_password" "$cred_database"
        exit 0
    fi

    # Connect to database
    connect_to_database "$client" "$cred_host" "$cred_port" "$cred_username" "$cred_password" "$cred_database"
}

# Run main function with all arguments
main "$@"
