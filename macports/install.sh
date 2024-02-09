#!/bin/zsh

~/.dotfiles/system/echos.zsh

echo-in-blue "Downloading MacPorts source code... ⬇️"
mkdir -p ~/macports
cd ~/macports
wget https://github.com/macports/macports-base/releases/download/v2.8.1/MacPorts-2.8.1.tar.bz2
tar xf MacPorts-2.8.1.tar.bz2

echo-in-blue "Installing MacPorts from code... 🛠"
echo_and_run cd MacPorts-2.8.1
echo_and_run ./configure --enable-readline --prefix=$HOME/macports --with-no-root-privileges
echo_and_run make && make install

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
echo_and_run port \
  -N `#Non-interactive mode` \
  install \
    bat \
    clojure \
    diff-so-fancy \
    diskonaut \
    gh \
    git \
    go \
    httpie \
    jenv \
    jq \
    leiningen \
    macos-trash \
    maven3 \
    mcfly \
    ncdu \
    npm10 \
    shellcheck \
    tealdeer \
    the_silver_searcher \
    tig \
    tree \
    youtube-dl \
    yt-dlp \
    zig \
    zsh
echo-in-green "Ports have been installed! ☑️"

TRAPEXIT() {
	echo-in-blue "File cleanup. 🗑"
    echo_and_run rm -f ~/macports/MacPorts-2.8.1.tar.bz2
}
