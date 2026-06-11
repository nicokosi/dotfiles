# Package Tracking Design

**Date:** 2026-06-11  
**Status:** Approved

## Goal

Track Homebrew (brew leaves) and Snap (user packages) in the dotfiles repo with automatic capture after install/remove, and restore on a new machine.

## Repository Structure

```
.dotfiles/
  packages/
    brew.txt          # One package per line — brew leaves output
    snap.txt          # One package per line — non-canonical snap packages
  fish/
    .config/fish/
      conf.d/
        packages.fish # Fish wrappers for brew and snap with auto-capture
```

## Package Files

### brew.txt

Populated by `brew leaves` — only explicitly installed packages (no transitive dependencies).

Initial content (current state):
```
diff-so-fancy
docker
docker-agent
docker-engine
fisher
gcc
gh
lazydocker
lazygit
mise
rootlesskit
slirp4netns
the_silver_searcher
tig
tldr
tree
```

### snap.txt

Populated by filtering `snap list` to non-canonical publishers only.

Filter criteria: exclude packages where publisher contains `canonical`.

Initial content (current state):
```
bitwarden
firefox
ghostty
intellij-idea-ultimate
pycharm-professional
```

## Auto-Capture Hook (packages.fish)

Fish does not support external command interception natively, so `brew` and `snap` are wrapped as fish functions. The wrappers:

1. Call the real binary (using `command brew` / `command snap`)
2. On `install` or `remove` subcommands: regenerate the relevant `.txt` file and commit to git

### brew wrapper

```fish
function brew
    command brew $argv
    if contains -- $argv[1] install remove uninstall
        _packages_capture_brew
    end
end
```

### snap wrapper

```fish
function snap
    command snap $argv
    if contains -- $argv[1] install remove
        _packages_capture_snap
    end
end
```

### Capture helpers

```fish
function _packages_capture_brew
    set -l dotfiles (path dirname (status filename))/../../../..
    command brew leaves > $dotfiles/packages/brew.txt
    git -C $dotfiles add packages/brew.txt
    git -C $dotfiles diff --cached --quiet; or git -C $dotfiles commit -m "chore: update brew packages"
end

function _packages_capture_snap
    set -l dotfiles (path dirname (status filename))/../../../..
    snap list | awk 'NR>1 && $5 !~ /canonical/ {print $1}' > $dotfiles/packages/snap.txt
    git -C $dotfiles add packages/snap.txt
    git -C $dotfiles diff --cached --quiet; or git -C $dotfiles commit -m "chore: update snap packages"
end
```

## Restore on New Machine (install.sh)

Two new sections added to `install.sh` after fish/fisher setup:

```bash
# Install brew packages
if command -v brew &>/dev/null && [ -f "$DOTFILES/packages/brew.txt" ]; then
  echo "→ Installing brew packages..."
  xargs brew install < "$DOTFILES/packages/brew.txt"
fi

# Install snap packages
if command -v snap &>/dev/null && [ -f "$DOTFILES/packages/snap.txt" ]; then
  echo "→ Installing snap packages..."
  while IFS= read -r pkg; do
    snap install "$pkg" || echo "  WARNING: snap install $pkg failed (may need --classic or --edge)"
  done < "$DOTFILES/packages/snap.txt"
fi
```

Note: `snap install` may require `--classic` or `--edge` for some packages (e.g. ghostty, intellij). These flags are not captured — on a new machine, the user will see warnings and can install manually.

## What Is Not Tracked

- Transitive brew dependencies (only `brew leaves`)
- Canonical system snap packages (core*, gnome-*, gtk-*, snapd, snap-store, etc.)
- Snap install flags (--classic, --edge, --channel)

## Stow

`packages/` contains only data files (no target path to symlink). They are accessed directly via `$DOTFILES/packages/` from both `install.sh` and `packages.fish`. No stow package needed for this directory.
