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
brew install brew-cask curl htop-osx lynx openssl rmtrash tree wget Caskroom/cask/xmind --with-cocoa --srgb emacs Caskroom/cask/gimp \
 Caskroom/cask/alfred Caskroom/cask/caffeine Caskroom/cask/chromium Caskroom/cask/iterm2 Caskroom/cask/spectacle Caskroom/cask/teamviewer \
 Caskroom/cask/cheatsheet Caskroom/cask/firefox-beta Caskroom/cask/openoffice Caskroom/cask/sublime-text3 Caskroom/cask/vlc-nightly Caskroom/cask/kobo Caskroom/cask/calibre
 Caskroom/cask/google-chrome

# virtual machines:
brew install boot2docker docker Caskroom/cask/virtualbox Caskroom/cask/vagrant

# development:
brew install git Caskroom/cask/java Caskroom/cask/java7 Caskroom/cask/java6 jenv maven tig Caskroom/cask/intellij-idea-ce Caskroom/cask/sbt Caskroom/cask/lighttable leiningen typesafe-activator

exit 0
