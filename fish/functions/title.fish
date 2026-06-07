function title
    # sets window title in xterm/screen/etc.
    set -l a (string replace -a '%' '%%' -- "$argv[1]")
    set a (string replace -a '\n' '' -- "$a")
    set a (string sub -l 40 -- "$a")

    switch $TERM
        case screen
            printf '\ek%s:%s\e\\' "$a" "$argv[3]"
        case 'xterm*' 'rxvt*'
            printf '\e]2;%s\a' "$argv[2]"
    end
end
