install_or_update_brew_app() {
    APP_NAME="$1"

    # Check if the application is already installed
    if brew list --cask "$APP_NAME" 2>/dev/null || brew list "$APP_NAME" 2>/dev/null; then
        # If it is installed, update and upgrade
        echo "Updating and upgrading $APP_NAME..."
        brew upgrade "$APP_NAME"
    else
        # If it's not installed, install the application
        echo "Installing $APP_NAME..."
        brew install "$APP_NAME"
    fi
}

git_clone_or_update() {
    # Check if a URL was provided
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Please provide a Git repository URL and a base directory."
        return 1
    fi
    REPO_URL="$1"
    BASE_DIR="$2"

    # Extract the directory name from the repository URL
    DIR_NAME=$(basename "$REPO_URL" .git)

    # Check if directory exists
    if [ -d "$BASE_DIR/$DIR_NAME" ]; then
        git -C "$BASE_DIR/$DIR_NAME" pull
    else
        # If it doesn't exist, clone the repository
        git clone "$REPO_URL" "$BASE_DIR/$DIR_NAME"
    fi
}

_a() {
    # kubectl config use-context "${1}"
    unset AWS_VAULT
    aws-vault exec "${1}"
}

# PostgreSQL Docker Helper Functions
pg_up() {
  local port="${1:-5432}"
  local version="${2:-16}"
  local container_name="${3:-postgres}"
  local db_name="${4:-flowtrip}"
  local db_user="${5:-flowtrip}"
  local db_password="${6:-postgres}"
  
  # Kill existing container if it exists
  docker kill "$container_name" 2>/dev/null || true
  
  echo "Starting PostgreSQL $version on port $port..."
  docker run \
    --rm \
    --name "$container_name" \
    -p "${port}:5432" \
    -e POSTGRES_USER="$db_user" \
    -e POSTGRES_PASSWORD="$db_password" \
    -e POSTGRES_DB="$db_name" \
    -d \
    postgres:$version
  
  echo "PostgreSQL is starting up on port $port..."
  echo "Connection string: postgresql://$db_user:$db_password@localhost:$port/$db_name"
}

pg_down() {
  local container_name="${1:-postgres}"
  echo "Stopping PostgreSQL container '$container_name'..."
  docker stop "$container_name" 2>/dev/null || echo "Container '$container_name' not found"
}

pg_status() {
  local container_name="${1:-postgres}"
  if docker ps | grep -q "$container_name"; then
    echo "PostgreSQL container '$container_name' is running:"
    docker ps --filter "name=$container_name" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
  else
    echo "PostgreSQL container '$container_name' is not running"
  fi
}

pg_logs() {
  local container_name="${1:-postgres}"
  local lines="${2:-50}"
  docker logs --tail "$lines" -f "$container_name"
}

pg_exec() {
  local container_name="${1:-postgres}"
  local db_name="${2:-flowtrip}"
  local db_user="${3:-flowtrip}"
  
  docker exec -it "$container_name" psql -U "$db_user" -d "$db_name"
}

pg_backup() {
  local container_name="${1:-postgres}"
  local db_name="${2:-flowtrip}"
  local db_user="${3:-flowtrip}"
  local backup_file="${4:-backup_$(date +%Y%m%d_%H%M%S).sql}"
  
  echo "Creating backup of $db_name to $backup_file..."
  docker exec "$container_name" pg_dump -U "$db_user" "$db_name" > "$backup_file"
  echo "Backup completed: $backup_file ($(ls -lh "$backup_file" | awk '{print $5}'))"
}

pg_restore() {
  local container_name="${1:-postgres}"
  local db_name="${2:-flowtrip}"
  local db_user="${3:-flowtrip}"
  local backup_file="$4"
  
  if [ -z "$backup_file" ]; then
    echo "Usage: pg_restore [container_name] [db_name] [db_user] <backup_file>"
    return 1
  fi
  
  if [ ! -f "$backup_file" ]; then
    echo "Backup file not found: $backup_file"
    return 1
  fi
  
  echo "Restoring $backup_file to $db_name..."
  docker exec -i "$container_name" psql -U "$db_user" "$db_name" < "$backup_file"
  echo "Restore completed"
}

pg_list() {
  echo "PostgreSQL containers:"
  docker ps -a --filter "ancestor=postgres" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}\t{{.Image}}"
}

pg_shell() {
  local container_name="${1:-postgres}"
  docker exec -it "$container_name" bash
}

pg_help() {
  cat << EOF
PostgreSQL Docker Helper Functions:

  pg_up [port] [version] [container] [db] [user] [pass]
    Start PostgreSQL container (defaults: 5432, 16, postgres, flowtrip, flowtrip, postgres)
    
  pg_down [container]
    Stop PostgreSQL container (default: postgres)
    
  pg_status [container]
    Show container status (default: postgres)
    
  pg_logs [container] [lines]
    Show container logs (defaults: postgres, 50)
    
  pg_exec [container] [db] [user]
    Open psql session (defaults: postgres, flowtrip, flowtrip)
    
  pg_backup [container] [db] [user] [file]
    Backup database to file (default filename: backup_YYYYMMDD_HHMMSS.sql)
    
  pg_restore [container] [db] [user] <file>
    Restore database from file (file is required)
    
  pg_list
    List all PostgreSQL containers
    
  pg_shell [container]
    Open bash shell in container (default: postgres)
    
  pg_help
    Show this help message

Examples:
  pg_up 5433 15              # Start PostgreSQL 15 on port 5433
  pg_up 5432 16 myapp        # Custom container name
  pg_backup                  # Quick backup with timestamp
  pg_exec                    # Quick psql access
EOF
}

function cloner {
   curl -H "Authorization: token $1" -s "https://api.github.com/orgs/$2/repos?per_page=100&page=${3:-"1"}" \
       | sed -n '/"ssh_url"/s/.*ssh_url": "\([^"]*\).*/\1/p' \
       | sort -u \
       | xargs -n1 git clone;
}

#
eks_config() {
  aws eks update-kubeconfig --name="${1}" --alias "${2}"
}


gh-browse() {
  local org=${1:-dnd-it}
  gh repo list $org -L 100 --json name | jq '.[].name' -r | fzf | xargs -I {} gh repo view --web $org/{}
}

