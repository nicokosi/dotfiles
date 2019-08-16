# Antigen
source "$HOME/.dotfiles/antigen/antigen.zsh"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Plugins
antigen-bundles <<EOBUNDLES
brew
docker
history
mvn
rupa/z
vagrant
zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen theme romkatv/powerlevel10k

antigen-apply

source $HOME/.antigen/bundles/rupa/z/z.sh