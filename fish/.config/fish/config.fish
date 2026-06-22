if status is-interactive
    # Commands to run in interactive sessions can go here
    zoxide init fish | source
    mcfly init fish | source
    eval "$(mise activate fish)"
end
eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
