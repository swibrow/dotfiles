#!/bin/bash

# Simple remote dotfiles installer using stow
set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Installing dotfiles for remote server...${NC}"

# Install stow if not present
if ! command -v stow &> /dev/null; then
    echo "Installing stow..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y stow git
    elif command -v yum &> /dev/null; then
        sudo yum install -y stow git
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm stow git
    else
        echo -e "${RED}Could not install stow. Please install it manually.${NC}"
        exit 1
    fi
fi

# Clone dotfiles repo
DOTFILES_DIR="$HOME/dotfiles"
if [ -d "$DOTFILES_DIR" ]; then
    echo "Updating existing dotfiles..."
    cd "$DOTFILES_DIR"
    git pull
else
    echo "Cloning dotfiles..."
    git clone https://github.com/swibrow/dotfiles.git "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
fi

# Stow essential configs for remote servers
echo "Applying configurations..."
stow vim
stow tmux
stow git
stow bash 2>/dev/null || true  # bash might not exist yet

echo -e "${GREEN}✓ Dotfiles installed successfully!${NC}"
echo "Restart your shell or run: source ~/.bashrc"