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
brew install brew-cask curl git htop-osx jenv lynx maven openssl rmtrash tree wget tig boot2docker docker \
 Caskroom/cask/virtualbox Caskroom/cask/xmind --with-cocoa --srgb emacs

exit 0
