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

pg_up() {
  docker kill postgres || true
  docker run \
    --rm \
    --name postgres \
    -p 5432:5432 \
    -e POSTGRES_USER=flowtrip \
    -e POSTGRES_PASSWORD=postgres \
    -e POSTGRES_DB=flowtrip \
    -d \
    postgres:16
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
