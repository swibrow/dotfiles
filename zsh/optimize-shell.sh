#!/bin/bash
# Shell optimization script
# This script will backup your current .zshrc and apply optimizations

set -e

DOTFILES_DIR="$HOME/dotfiles"
ZSH_DIR="$DOTFILES_DIR/zsh"
BACKUP_DIR="$ZSH_DIR/backup-$(date +%Y%m%d_%H%M%S)"

echo "🚀 Optimizing shell startup performance..."

# Create backup
mkdir -p "$BACKUP_DIR"
cp "$ZSH_DIR/.zshrc" "$BACKUP_DIR/.zshrc.original"
echo "✅ Backup created at: $BACKUP_DIR"

# Apply optimized configuration
cp "$ZSH_DIR/.zshrc.optimized" "$ZSH_DIR/.zshrc"
echo "✅ Applied optimized configuration"

# Test the new configuration
echo "🧪 Testing optimized shell..."
time zsh -i -c exit > /tmp/shell_test.log 2>&1 || {
    echo "❌ Optimized shell failed, restoring backup..."
    cp "$BACKUP_DIR/.zshrc.original" "$ZSH_DIR/.zshrc"
    echo "⚠️  Backup restored. Check /tmp/shell_test.log for errors"
    exit 1
}

echo "✨ Shell optimization complete!"
echo "📈 Test your new shell speed with: time zsh -i -c exit"
echo "🔄 If you experience issues, restore with: cp $BACKUP_DIR/.zshrc.original $ZSH_DIR/.zshrc"