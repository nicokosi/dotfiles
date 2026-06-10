#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Check stow is available
if ! command -v stow &>/dev/null; then
  echo "ERROR: GNU Stow is not installed."
  echo "Install it with: sudo apt install stow  OR  brew install stow"
  exit 1
fi

# 2. Stow fish package
echo "→ Stowing fish config..."
cd "$DOTFILES"
stow --verbose fish

# 3. Install fisher if not present
if ! fish -c "type -q fisher" &>/dev/null; then
  echo "→ Installing fisher..."
  fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
fi

# 4. Install plugins
echo "→ Installing fish plugins..."
fish -c "fisher update"

echo ""
echo "✓ Done! Run 'tide configure' to set up your prompt."
