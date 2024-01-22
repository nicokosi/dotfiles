#!/bin/zsh

~/.dotfiles/system/echos.zsh

macports-upgrades() {
  echo-in-blue "Upgrading MacPorts"
  echo_and_run port selfupdate && port upgrade outdated
  echo-in-green "Done!"
}
