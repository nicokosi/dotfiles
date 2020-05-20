# Antigen
source "$HOME/antigen.zsh"

antigen use oh-my-zsh

antigen bundles <<EOBUNDLES
arialdomartini/oh-my-git
docker
# git
gitignore
gradle
history
mvn
rupa/z
vagrant
zsh-users/zsh-syntax-highlighting
EOBUNDLES

antigen theme arialdomartini/oh-my-git-themes oppa-lana-style

antigen apply

source $HOME/.antigen/bundles/rupa/z/z.sh