# fzf: key bindings and fuzzy completion
if command -sq fzf
    fzf --fish | source
end

# mise: dev tools version manager
if command -sq mise
    /usr/local/bin/mise activate fish | source
end

# mcfly: enhanced shell history search
if command -sq mcfly
    mcfly init fish | source
end
