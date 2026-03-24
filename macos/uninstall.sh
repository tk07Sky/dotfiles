#!/bin/bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info()    { echo -e "${BLUE}[info]${NC}  $*"; }
success() { echo -e "${GREEN}[ok]${NC}    $*"; }
warn()    { echo -e "${YELLOW}[warn]${NC}  $*"; }

unlink_dotfile() {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        rm "$dst"
        success "removed: $dst"
    else
        warn "not a managed symlink, skipping: $dst"
    fi
}

info "dotfiles: $DOTFILES_DIR"

# ~/.config
unlink_dotfile "$DOTFILES_DIR/config/starship.toml"        "$HOME/.config/starship.toml"
unlink_dotfile "$DOTFILES_DIR/config/sheldon/plugins.toml" "$HOME/.config/sheldon/plugins.toml"
unlink_dotfile "$DOTFILES_DIR/config/tmux/tmux.conf"       "$HOME/.config/tmux/tmux.conf"
unlink_dotfile "$DOTFILES_DIR/config/ghostty/config"       "$HOME/.config/ghostty/config"

# Git
unlink_dotfile "$DOTFILES_DIR/git/gitconfig" "$HOME/.gitconfig"

# Zsh
unlink_dotfile "$DOTFILES_DIR/zsh/zsh_alias" "$HOME/.zsh_alias"
unlink_dotfile "$DOTFILES_DIR/zsh/zsh_functions" "$HOME/.zsh_functions"
unlink_dotfile "$DOTFILES_DIR/zsh/zsh_optrc" "$HOME/.zsh_optrc"

# .zshrc cleanup
ZSHRC="$HOME/.zshrc"
SOURCE_STR="[ -f \"$HOME/.zsh_optrc\" ] && source \"$HOME/.zsh_optrc\""

if [ -f "$ZSHRC" ]; then
    if grep -qF "$SOURCE_STR" "$ZSHRC"; then
        sed -i '' "\|$SOURCE_STR|d" "$ZSHRC"
        success "removed source line from $ZSHRC"
    fi
fi

success "Done!"
