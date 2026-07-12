# Chezmoi
cm() { [ $# -eq 0 ] && chezmoi cd || chezmoi "$@"; }
compdef cm=chezmoi

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

function cloner {
   curl -H "Authorization: token $1" -s "https://api.github.com/orgs/$2/repos?per_page=100&page=${3:-"1"}" \
       | sed -n '/"ssh_url"/s/.*ssh_url": "\([^"]*\).*/\1/p' \
       | sort -u \
       | xargs -n1 git clone;
}

# Mirror a git repo from one org to another
git_mirror_to_org() {
  local source_org="$1"
  local repo_name="$2"
  local target_org="$3"
  local visibility="${4:-private}"

  if [ -z "$source_org" ] || [ -z "$repo_name" ] || [ -z "$target_org" ]; then
    echo "Usage: git_mirror_to_org <source_org> <repo_name> <target_org> [visibility]"
    echo "  visibility: private (default) or public"
    return 1
  fi

  local tmp_dir=$(mktemp -d)
  echo "Mirroring $source_org/$repo_name to $target_org/$repo_name..."

  # Clone as bare mirror
  echo "Cloning mirror from $source_org/$repo_name..."
  if ! git clone --mirror "git@github.com:$source_org/$repo_name.git" "$tmp_dir/$repo_name.git"; then
    echo "Failed to clone from source"
    rm -rf "$tmp_dir"
    return 1
  fi

  # Remove GitHub PR refs (read-only, can't be pushed)
  git -C "$tmp_dir/$repo_name.git" for-each-ref --format='delete %(refname)' refs/pull | \
    git -C "$tmp_dir/$repo_name.git" update-ref --stdin

  # Create repo in target org
  echo "Creating repo in $target_org..."
  gh repo create "$target_org/$repo_name" --"$visibility" 2>/dev/null || echo "Repo may already exist, continuing..."

  # Push mirror to target
  echo "Pushing mirror to $target_org/$repo_name..."
  if ! git -C "$tmp_dir/$repo_name.git" push --mirror "git@github.com:$target_org/$repo_name.git"; then
    echo "Failed to push to target"
    rm -rf "$tmp_dir"
    return 1
  fi

  # Cleanup
  rm -rf "$tmp_dir"
  echo "Successfully mirrored $source_org/$repo_name to $target_org/$repo_name"
}

gh-browse() {
  local org=${1:-dnd-it}
  gh repo list $org -L 100 --json name | jq '.[].name' -r | fzf | xargs -I {} gh repo view --web $org/{}
}

# AWS profile switching function using native AWS CLI
function af {
  # Get list of AWS profiles from ~/.aws/config
  local profile=$(aws configure list-profiles | fzf)
  if [ -n "$profile" ]; then
    export AWS_PROFILE="$profile"
    echo "✓ Switched to AWS profile: $profile"

    # Try to verify credentials, if it fails, trigger SSO login
    if ! aws sts get-caller-identity &>/dev/null; then
      echo "📝 SSO session expired. Logging in..."
      if aws sso login --profile "$profile"; then
        echo "✓ Successfully logged in"
        # Give AWS a moment to propagate credentials
        sleep 1
        # Verify the session is working
        local identity=$(aws sts get-caller-identity --query 'Account' --output text 2>/dev/null)
        if [ -n "$identity" ]; then
          echo "✓ Verified access to account: $identity"
          local user=$(aws sts get-caller-identity --query 'Arn' --output text 2>/dev/null | sed 's/.*\///')
          echo "✓ Logged in as: $user"
        else
          echo "⚠️  Warning: Could not verify credentials immediately. Try running a command to test."
        fi
      else
        echo "✗ Failed to login"
        unset AWS_PROFILE
        return 1
      fi
    else
      local account=$(aws sts get-caller-identity --query Account --output text 2>/dev/null)
      local user=$(aws sts get-caller-identity --query 'Arn' --output text 2>/dev/null | sed 's/.*\///')
      echo "✓ Using existing session for account: $account"
      echo "✓ Logged in as: $user"
    fi
  fi
}
