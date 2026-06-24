function echo-in
    set -l no_color "\033[0m"
    if test (count $argv) -ge 2
        set -l color $argv[1]
        set -l text $argv[2..-1]
        echo -e "$color"(string join ' ' -- $text)"$no_color"
    else
        echo -e (string join ' ' -- $argv)
    end
end

function echo-in-light-cyan
    echo-in "\033[0;96m" $argv
end

function echo-in-blue
    echo-in "\033[0;34m" $argv
end

function echo-in-green
    echo-in "\033[0;92m" $argv
end

function echo_and_run
    if test (count $argv) -eq 0
        return 0
    end

    echo-in-light-cyan (string join ' ' -- $argv)
    $argv[1] $argv[2..-1]
end

function brew-upgrades
    echo-in-blue "Upgrading brew"
    echo_and_run brew update
    and echo_and_run brew upgrade

    echo-in-blue "Upgrading brew cask"
    for outdated in (brew outdated --cask --quiet)
        if test -n "$outdated"
            echo_and_run brew reinstall --cask $outdated
        end
    end

    echo-in-blue "Cleanup"
    echo_and_run brew cleanup -s
    echo-in-green "Done!"
end

function macports-upgrades
    echo-in-blue "Upgrading MacPorts"
    echo_and_run sudo port selfupdate
    and echo_and_run sudo port upgrade outdated
    echo-in-green "Done!"
end

function update-all
    echo-in-blue "Update Homebrew (applications)..."
    echo_and_run brew-upgrades
    echo-in-green "Homebrew updated!"

    echo-in-blue "Update MacPorts (applications)..."
    echo_and_run macports-upgrades
    echo-in-green "MacPorts updated!"

    echo-in-blue "Update Rust env..."
    echo_and_run rustup update
    echo "Rust env updated!"
end

function disk-cleanup
    echo "Space before cleanup:"
    df -h | grep '/dev/disk1'

    for item in ~/Library/Caches/*
        if test -e "$item"
            rm -rf "$item"
        end
    end
    echo "App cache cleanup 🖥\n"

    brew cleanup --prune=all
    echo "Brew cleanup 🍻\n"

    docker system prune --all --force
    docker rmi --force (docker images --all --quiet)
    docker rm --force (docker ps --all --quiet)
    echo "Docker cleanup 🐳\n"

    for item in ~/.m2/repository/*
        if test -e "$item"
            rm -rf "$item"
        end
    end

    for item in ~/.gradle/caches/*
        if test -e "$item"
            rm -rf "$item"
        end
    end
    for project in (ls)
        if test -e "$project/build.gradle.kts"
            "./$project/gradlew" clean
        end
    end
    echo "Gradle cleanup 🐘\n"

    for item in ~/.ivy2/cache/*
        if test -e "$item"
            rm -rf "$item"
        end
    end
    echo "Ivy cleanup 🐜\n"

    echo "Space after cleanup:"
    df -h | grep '/dev/disk1'
end

function gdl
    if test -e ./gradlew
        ./gradlew $argv
    else
        gradle $argv
    end
end

function gifify
    if test (count $argv) -lt 1
        echo "Transforms a video into an animated GIF. 🎬"
        echo "Usage:"
        echo "    gifify input output rate"
        echo "        input: path of the input video file (mandatory)"
        echo "        output: path of the output animated gif file (optional, default is 'output.gif')"
        echo "        rate: rate per second (optional, default is 4)"
        return 1
    end

    set -l input $argv[1]
    set -l output output.gif
    set -l rate 4

    if test (count $argv) -ge 2
        set output $argv[2]
    end

    if test (count $argv) -ge 3
        set rate $argv[3]
    end

    ffmpeg -i "$input" -r "$rate" "$output"
end
