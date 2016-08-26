#!/bin/sh
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

# Check for Homebrew
if test ! $(which brew)
then
  echo "  Installing Homebrew for you."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install homebrew packages

# "base":
brew install \
  brew-cask \
  curl \
  lynx \
  openssl \
  rmtrash \
  tree \
  wget \
  Caskroom/cask/xmind --with-cocoa --srgb \
  emacs \
  Caskroom/cask/gimp \
  Caskroom/cask/alfred \
  Caskroom/cask/caffeine \
  Caskroom/cask/chromium \
  Caskroom/cask/iterm2 \
  Caskroom/cask/spectacle \
  Caskroom/cask/teamviewer \
  Caskroom/cask/cheatsheet \
  Caskroom/versions/firefox-beta \
  Caskroom/cask/openoffice \
  Caskroom/versions/sublime-text \
  Caskroom/versions/vlc-nightly \
  Caskroom/cask/kobo \
  Caskroom/cask/calibre \
  Caskroom/cask/google-chrome \
  Caskroom/cask/disk-inventory-x \
  htop \
  httpie

# virtual machines:
brew install \
  docker \
  Caskroom/cask/virtualbox \
  Caskroom/cask/vagrant

# development:
brew install \
  git \
  Caskroom/cask/java \
  Caskroom/versions/java6 \
  Caskroom/versions/java7 \
  jenv \
  maven \
  tig \
  Caskroom/versions/intellij-idea-ce \
  sbt \
  Caskroom/cask/lighttable \
  leiningen \
  typesafe-activator \
  Caskroom/cask/postman \
  Caskroom/cask/haskell-platform
exit 0
