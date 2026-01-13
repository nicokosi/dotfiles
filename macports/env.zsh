alias port-export-installed-bundle='port echo requested > ~/.dotfiles/macports/installed_ports.txt'
alias port-import-installed-bundle='while read -r line; do
    port install "${line%% *}"
done < ~/.dotfiles/macports/installed_ports.txt'

export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="/usr/local/opt/trash/bin:$PATH"
