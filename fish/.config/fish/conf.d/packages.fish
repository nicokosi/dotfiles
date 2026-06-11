function _packages_dotfiles_root
    # Resolve symlink first, then walk up 4 levels to .dotfiles root
    set -l real (realpath (status filename))
    path normalize (path dirname $real)/../../../..
end

function _packages_capture_brew
    set -l dotfiles (_packages_dotfiles_root)
    command brew leaves > $dotfiles/packages/brew.txt
    git -C $dotfiles add packages/brew.txt
    git -C $dotfiles diff --cached --quiet
    or git -C $dotfiles commit -m "chore: update brew packages"
end

function _packages_capture_snap
    set -l dotfiles (_packages_dotfiles_root)
    command snap list | awk 'NR>1 && $5 !~ /canonical/ {print $1}' > $dotfiles/packages/snap.txt
    git -C $dotfiles add packages/snap.txt
    git -C $dotfiles diff --cached --quiet
    or git -C $dotfiles commit -m "chore: update snap packages"
end

function brew
    command brew $argv
    set -l exit_code $status
    if test $exit_code -eq 0; and contains -- $argv[1] install remove uninstall
        _packages_capture_brew
    end
    return $exit_code
end

function snap
    command snap $argv
    set -l exit_code $status
    if test $exit_code -eq 0; and contains -- $argv[1] install remove
        _packages_capture_snap
    end
    return $exit_code
end
