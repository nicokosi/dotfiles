echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}${2}${NO_COLOR}"
}
echo-in-blue() { echo-in "\033[0;34m" $1}
echo-in-green() { echo-in "\033[0;92m" $1}

brew-upgrades() {
  echo-in-blue "Upgrading brew"
  brew update
  brew upgrade --cleanup

  echo-in-blue "Upgrading mas"
  mas upgrade

  echo-in-blue "Upgrading brew cask"
  for outdated in "${(@f)$(brew cask outdated --quiet)}"
  do
    if [[ !  -z  $outdated  ]]
    then
      brew cask reinstall $outdated
    fi
  done

  echo-in-blue "Cleanup"
  brew cleanup
  brew cask cleanup

  echo-in-green "Done!"
}
