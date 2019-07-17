#!/bin/zsh

echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}${2}${NO_COLOR}"
}
echo-in-blue() { echo-in "\033[0;34m" $1}

brew-upgrades() {
  echo-in-blue "Upgrading brew"
  brew update
  brew upgrade

  echo "Cleanup"
  brew cleanup -s
  echo "Done!"
}
