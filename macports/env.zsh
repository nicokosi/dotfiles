alias port-export-installed-bundle='port installed requested > ~/.dotfiles/macports/installed_ports.txt'
alias port-import-installed-bundle='while read -r line; do
    port install "${line%% *}"
done < ~/.dotfiles/macports/installed_ports.txt'
