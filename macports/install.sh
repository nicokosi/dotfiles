#!/bin/zsh

echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}${2}${NO_COLOR}"
}
echo-in-blue() { echo-in "\033[0;34m" $1}


echo-in-blue "Downloading MacPorts source code... ⬇️"
mkdir -p ~/macports
cd ~/macports
wget https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1.tar.bz2
tar xf MacPorts-2.8.1.tar.bz2

echo-in-blue "Installing MacPorts from code... 🛠"
cd MacPorts-2.8.1
./configure --enable-readline --prefix=$HOME/macports --with-no-root-privileges
make && make install

#echo-in-blue "Configuring the shell for MacPorts... ⚙️"
# bash
#echo "export MACPORTS_HOME=\\$HOME/macports" >> ~/.bash_profile
#echo "export PATH=\\$MACPORTS_HOME/bin:\\$MACPORTS_HOME/sbin" >> ~/.bash_profile
# zsh
#echo "export MACPORTS_HOME=\\$HOME/macports" >> ~/.zprofile
#echo "export PATH=\\$MACPORTS_HOME/bin:\\$MACPORTS_HOME/sbin" >> ~/.zshrc
# fish
#echo "set -gx MACPORTS_HOME \\$HOME/macports" >> ~/.config/fish/config.fish
#echo "set -gx PATH $MACPORTS_HOME/bin $MACPORTS_HOME/sbin" >> ~/.config/fish/config.fish

echo-in-blue "MacPorts has been installed to run with no root privileges! ☑️"

echo-in-blue "Installing ports... ⤵️"
port \
  -N `#Non-interactive mode` \
  install \
    bat \
    diff-so-fancy \
    gh \
    git \
    go \
    jenv \
    macos-trash \
    maven3 \
    mcfly \
    npm10 \
    tealdeer \
    the_silver_searcher \
    tig \
    youtube-dl \
    yt-dlp \
    zsh
echo-in-blue "Ports have been installed! ☑️"

TRAPEXIT() {
	echo-in-blue "File cleanup. 🗑"
    rm -f ~/macports/MacPorts-2.8.1.tar.bz2
}