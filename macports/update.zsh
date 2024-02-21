#!/bin/zsh

~/.dotfiles/system/echos.zsh

macports-upgrades() {
  echo-in-blue "Upgrading MacPorts"
  echo_and_run sudo port selfupdate && sudo port upgrade outdated
  echo-in-green "Done!"
}
