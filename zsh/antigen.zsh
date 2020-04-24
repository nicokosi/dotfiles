# Antigen
source "$HOME/antigen.zsh"
# Load the oh-my-zsh's library.
antigen use oh-my-zsh
# Plugins
antigen bundles <<EOBUNDLES
docker
mvn
gitignore
history
vagrant
rupa/z
arialdomartini/oh-my-git
zsh-users/zsh-syntax-highlighting
gradle
EOBUNDLES

antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

antigen apply
