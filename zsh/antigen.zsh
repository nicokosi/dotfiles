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
arialdomartini/oh-my-git
zsh-users/zsh-syntax-highlighting
EOBUNDLES

export PS1="%~ • "

antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

antigen-apply
