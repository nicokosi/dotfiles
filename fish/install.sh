#!/bin/sh

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required to install fish."
  exit 1
fi

brew install fish
FISH_PATH="$(command -v fish)"
if [ -z "$FISH_PATH" ]; then
  echo "fish shell not found after installation"
  exit 1
fi
# Add fish to /etc/shells if not already there
grep -q "$FISH_PATH" /etc/shells || echo "$FISH_PATH" | sudo tee -a /etc/shells
# Create config dir
mkdir -p ~/.config/fish
mkdir -p ~/.config/fish/conf.d
mkdir -p ~/.config/fish/functions
ln -sf "$DOTFILES_DIR/fish/config.fish.symlink" ~/.config/fish/config.fish

brew reinstall zoxide
zoxide init fish | source
