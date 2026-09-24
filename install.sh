#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Check stow is available
if ! command -v stow &>/dev/null; then
  echo "ERROR: GNU Stow is not installed."
  echo "Install it with: sudo apt install stow  OR  brew install stow"
  exit 1
fi

# 2. Check fish is available
if ! command -v fish &>/dev/null; then
  echo "ERROR: fish shell is not installed."
  echo "Install it with: sudo apt install fish  OR  brew install fish"
  echo "See https://fishshell.com for more options."
  exit 1
fi

# 3. Stow fish package
echo "→ Stowing fish config..."
mkdir -p ~/.config/fish/conf.d
cd "$DOTFILES"
stow --verbose --restow fish || {
  echo "ERROR: stow failed — a conflicting file already exists."
  echo "Remove conflicting files under ~/.config/fish/ then re-run:"
  echo "  rm -rf ~/.config/fish/config.fish ~/.config/fish/fish_plugins"
  echo "Or let stow take ownership (review diff after):"
  echo "  stow --adopt fish && git diff"
  exit 1
}

# 4. Stow github package (Copilot instructions)
echo "→ Stowing github config..."
mkdir -p ~/.github
cd "$DOTFILES"
stow --verbose --restow github || {
  echo "ERROR: stow failed — a conflicting file already exists."
  echo "Remove conflicting files under ~/.github/ then re-run:"
  echo "  rm -f ~/.github/copilot-instructions.md"
  echo "Or let stow take ownership (review diff after):"
  echo "  stow --adopt github && git diff"
  exit 1
}

# 5. Install fisher if not present
if ! fish -c "type -q fisher" &>/dev/null; then
  echo "→ Installing fisher..."
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fi

# 6. Install plugins
echo "→ Installing fish plugins..."
fish -c "fisher update"

# 7. Install brew packages
if command -v brew &>/dev/null && [ -f "$DOTFILES/packages/brew.txt" ]; then
  echo "→ Installing brew packages..."
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    brew install "$pkg" || echo "  WARNING: brew install $pkg failed"
  done < "$DOTFILES/packages/brew.txt"
fi

# 8. Install snap packages
if command -v snap &>/dev/null && [ -f "$DOTFILES/packages/snap.txt" ]; then
  echo "→ Installing snap packages..."
  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    snap install "$pkg" || echo "  WARNING: snap install $pkg failed (may need --classic or --edge)"
  done < "$DOTFILES/packages/snap.txt"
fi

echo ""
echo "✓ Done! Run 'tide configure' to set up your prompt."
