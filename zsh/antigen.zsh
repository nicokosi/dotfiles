# Antigen
source "$HOME/.dotfiles/antigen/antigen.zsh"

antigen use oh-my-zsh

# Plugins
antigen-bundles <<EOBUNDLES
arialdomartini/oh-my-git
brew
docker
history
mvn
rupa/z
vagrant
zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

antigen-apply

source $HOME/.antigen/bundles/rupa/z/z.sh