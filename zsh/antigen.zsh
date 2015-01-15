# Antigen
source "$HOME/.dotfiles/antigen/antigen.zsh"
# Load the oh-my-zsh's library.
antigen use oh-my-zsh
# Plugins
antigen-bundles <<EOBUNDLES
git
brew
docker
mvn
gitignore
history
vagrant
EOBUNDLES
antigen-apply