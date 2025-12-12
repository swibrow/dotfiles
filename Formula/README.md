# Homebrew Tap for Dotfiles

This directory contains the Homebrew formula for installing these dotfiles.

## Installation

### Option 1: Direct from GitHub (Recommended)
```bash
# Add the tap
brew tap swibrow/dotfiles https://github.com/swibrow/dotfiles

# Install dotfiles
brew install swibrow/dotfiles/dotfiles
```

### Option 2: Local Installation (for testing)
```bash
# From the dotfiles directory
brew install --build-from-source Formula/dotfiles.rb
```

## Usage

After installation, you'll have these commands available:

- `dotfiles-install` - Initial setup of dotfiles
- `dotfiles-update` - Pull latest changes and re-stow
- `dotfiles-uninstall` - Remove symlinks (keeps dotfiles directory)

## What it does

1. Clones/updates the dotfiles repository to `~/dotfiles`
2. Uses GNU Stow to create symlinks for all configuration
3. Sets up all necessary dependencies
4. Provides management commands for easy updates

## Uninstallation

To completely remove:
```bash
# Remove symlinks
dotfiles-uninstall

# Uninstall the formula
brew uninstall swibrow/dotfiles/dotfiles

# Optionally remove the dotfiles directory
rm -rf ~/dotfiles
```