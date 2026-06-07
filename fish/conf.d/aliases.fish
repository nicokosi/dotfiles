if command -sq gls
    function ls
        gls -F --color $argv
    end

    function l
        gls -lAh --color $argv
    end

    function ll
        gls -l --color $argv
    end

    function la
        gls -A --color $argv
    end
end

if command -sq hub
    function git --wraps git
        hub $argv
    end
end

function g
    git $argv
end

function ga
    git add $argv
end

function gap
    git add -p $argv
end

function gb
    git branch --sort=committerdate $argv
end

function gbr
    git branch --remote --sort=committerdate $argv
end

function gc
    git commit $argv
end

function gca
    git commit -a $argv
end

function gcb
    git copy-branch-name $argv
end

function gco
    git checkout $argv
end

function gd
    git diff $argv
end

function gf
    git fetch $argv
end

function gl
    git pull --prune $argv
end

function glo
    git log --oneline --decorate --color $argv
end

function glog
    git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative $argv
end

function gp
    git push origin HEAD $argv
end

function gpf
    git push --force-with-lease $argv
end

function grh
    git reset --hard '@{u}' $argv
end

function gs
    git status -sb $argv
end

function gst
    git status $argv
end

function gsw
    git switch $argv
end

function grip-browser
    grip --browser --quiet $argv
end

function preview-readme
    grip-browser $argv
end

function readme-preview
    grip-browser $argv
end

function spin-while-running
    gum spin --spinner dot --title 'loading...' --show-output -- $argv
end

function port-export-installed-bundle
    port echo requested > ~/.dotfiles/macports/installed_ports.txt
end

function port-import-installed-bundle
    while read -l line
        set -l package (string split ' ' -- $line)[1]
        if test -n "$package"
            port install "$package"
        end
    end < ~/.dotfiles/macports/installed_ports.txt
end

function mvn-vidal
    mvn --settings ~/.m2/vidal-settings.xml $argv
end

function mvn-update-deps-to-latest-patch
    mvn versions:use-latest-versions -DallowAnyUpdates=false -DallowMajorUpdates=false -DallowMinorUpdates=false -DallowIncrementalUpdates=true -DallowSnapshots=false $argv
end

function n
    nu --commands (string join ' ' -- $argv)
end

function pelican-quickstart
    env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 command pelican-quickstart $argv
end

function pelican-make-html
    env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 make html $argv
end

function pelican-make-serve
    env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 make serve $argv
end

function pelican-make-regenerate
    env LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 make regenerate $argv
end

function rust-lint
    cargo clippy $argv
end

function rust-repl
    evcxr $argv
end

function upgrade
    echo '\033[0;34mUpgrade shell (fish) and apps (via brew)\033[0m'
    brew-upgrades $argv
end

function minimalShellPrompt
    function fish_prompt
        printf '$ '
    end

    function fish_right_prompt
    end
end

function code
    '/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code' $argv
end

function ag
    command ag --mmap $argv
end

function brew-cask-info-versions
    for x in (brew list --cask)
        brew info --cask $x 2>/dev/null | head -n 1
    end
end

function brew-info-versions
    for x in (brew list)
        brew info $x 2>/dev/null | head -n 1
    end
end

function reload
    source ~/.config/fish/config.fish
end

function h
    history | fzf
end
