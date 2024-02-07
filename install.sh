#!/bin/bash

# Variables
DOTFILES_REPO="https://github.com/swibrow/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
DOTFILES_BACKUP_DIR="$HOME/.dotfiles-backup"

TIMESTAMP=$(date "+%Y%m%d_%H%M%S")

# Clone dotfiles repository
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
else
    echo "$DOTFILES_DIR already exists. Pulling latest changes..."
    git -C "$DOTFILES_DIR" pull
fi

# Create backup directory
if [ ! -d "$DOTFILES_BACKUP_DIR" ]; then
    mkdir "$DOTFILES_BACKUP_DIR"
fi

# Move existing dotfiles to backup directory
echo "Backing up existing dotfiles..."
files=(.zshrc .zprofile .zsh_functions Taskfile.yaml .Brewfile .gitconfig .env)

for file in "${files[@]}"; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        echo "Moving $file to $DOTFILES_BACKUP_DIR/${TIMESTAMP}_$file"
        mv "$HOME/$file" "$DOTFILES_BACKUP_DIR/${TIMESTAMP}_$file"
    fi
done

# Create symlinks
for file in "${files[@]}"; do
    ln -sf "$DOTFILES_DIR/$file" "$HOME/$file"
done

# Run Personal Dotfile Install Script
if [ -f "$DOTFILES_DIR/dotfiles-personal/install.sh" ]; then
    echo "Running personal dotfile install script..."
    "$DOTFILES_DIR/dotfiles-personal/install.sh"
else
    echo "Personal dotfile install script not found."
fi


source "$HOME/.zsh_functions"


###############################################################################
################################ HOMEBREW #####################################
###############################################################################

# Check if the OS is macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Detected macOS."

    # Check if Homebrew is installed
    if command -v brew &>/dev/null; then
        echo "Homebrew is already installed."
    else
        echo "Homebrew is not installed. Would you like to install it now? (y/n)"
        read -r response
        if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        else
            echo "Homebrew will not be installed."
        fi
    fi
    brew bundle --global --verbose --no-lock
else
    echo "This is not macOS. Exiting."
fi

###############################################################################
############################### OH MY ZSH #####################################
###############################################################################

# Install Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh is already installed."
else
    echo "Installing Oh My Zsh..."
    /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Oh My Zsh plugins
repos=(
    "https://github.com/johanhaleby/kubetail.git"
    "https://github.com/zsh-users/zsh-autosuggestions.git"
    "https://github.com/zsh-users/zsh-syntax-highlighting.git"
    "https://github.com/zsh-users/zsh-completions.git"
    "https://github.com/zsh-users/zsh-history-substring-search"
    "https://github.com/blimmer/zsh-aws-vault.git"
    "https://github.com/johanhaleby/kubetail.git"
)

# Loop through the plugins and clone or update them
for repo in "${repos[@]}"; do
    git_clone_or_update "$repo" "${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins"
done
