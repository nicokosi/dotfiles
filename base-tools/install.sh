apt-add-repository ppa:diodon-team/stable
apt install \
  diodon \
  ditaa \
  gist \
  htop \
  httpie \
  install \
  p7zip-full \
  recordmydesktop gtk-recordmydesktop \
  shellcheck \
  silversearcher-ag \
  sublime-text \
  terminator \
  trash-cli \
  tree \
  xmind \
  xmlstarlet \
  zip \

wget https://github.com/bcicen/ctop/releases/download/v0.6.1/ctop-0.6.1-linux-amd64 -O /usr/local/bin/ctop
chmod +x /usr/local/bin/ctop

go get github.com/cespare/reflex
go install github.com/cespare/reflex
