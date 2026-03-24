#!/bin/bash

set -euo pipefail

# Install Homebrew
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [ "$(uname -m)" = "arm64" ] ; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[info]${NC}  $*"; }
success() { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC}  $*"; }

link() {
    local src="$1"
    local dst="$2"

    mkdir -p "$(dirname "$dst")"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        success "already linked: $dst"
        return
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$dst" "$BACKUP_DIR/"
        warn "backed up: $dst → $BACKUP_DIR/"
    fi

    ln -s "$src" "$dst"
    success "linked: $dst"
}

info "dotfiles: $DOTFILES_DIR"

# ~/.config
link "$DOTFILES_DIR/config/starship.toml"        "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/config/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
link "$DOTFILES_DIR/config/tmux/tmux.conf"       "$HOME/.config/tmux/tmux.conf"
link "$DOTFILES_DIR/config/ghostty/config"       "$HOME/.config/ghostty/config"

# Git
link "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

# Zsh
link "$DOTFILES_DIR/zsh/zsh_alias" "$HOME/.zsh_alias"
link "$DOTFILES_DIR/zsh/zsh_functions" "$HOME/.zsh_functions"
link "$DOTFILES_DIR/zsh/zsh_optrc" "$HOME/.zsh_optrc"

# Brewfile
if [ -f "$DOTFILES_DIR/config/homebrew/Brewfile" ]; then
    info "Installing Homebrew dependencies..."
    brew bundle --file="$DOTFILES_DIR/config/homebrew/Brewfile"
fi

# Volta
info "Installing Volta..."
if ! command -v volta &> /dev/null; then
    curl https://get.volta.sh | bash
    success "Volta installed"
else
    success "Volta is already installed"
fi

# .zshrc setup
ZSHRC="$HOME/.zshrc"
SOURCE_STR="[ -f \"$HOME/.zsh_optrc\" ] && source \"$HOME/.zsh_optrc\""

if [ ! -f "$ZSHRC" ]; then
    touch "$ZSHRC"
    success "created: $ZSHRC"
fi

if ! grep -qF "$SOURCE_STR" "$ZSHRC"; then
    echo "$SOURCE_STR" >> "$ZSHRC"
    success "added source line to $ZSHRC"
else
    success "source line already exists in $ZSHRC"
fi

source "$ZSHRC"

success "Done!"
