if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    mcfly init fish | source
end
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
