echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}${2}${NO_COLOR}"
}
echo-in-blue() { echo-in "\033[0;34m" $1}

macports-upgrades() {
  echo-in-blue "Upgrading MacPorts"
  sudo port selfupdate
  sudo port upgrade outdated

  echo "Cleanup"
  brew cleanup -s
  echo "Done!"
}
