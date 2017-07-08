alias brew-upgrades="brew update && brew upgrade --cleanup && mas upgrade && for outdated in `brew cask outdated --quiet` ; brew cask reinstall $outdated && brew cleanup && brew cask cleanup"
