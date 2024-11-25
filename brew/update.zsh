#!/bin/zsh

~/.dotfiles/system/echos.zsh

brew-upgrades() {
  echo-in-blue "Upgrading brew"
  echo_and_run brew update && brew upgrade

  echo-in-blue "Upgrading brew cask"
  for outdated in "${(@f)$(brew outdated --cask --quiet)}"
  do
    if [[ !  -z  $outdated  ]]
    then
      echo_and_run brew reinstall --cask $outdated
    fi
  done

  echo-in-blue "Cleanup"
  echo_and_run brew cleanup -s
  echo-in-green "Done!"
}
