#!/bin/zsh

~/.dotfiles/system/echos.zsh

macports-upgrades() {
  echo-in-blue "Upgrading MacPorts"
  port selfupdate
  port upgrade outdated

  echo "Cleanup"
  brew cleanup -s
  echo "Done!"
}
