#!/bin/sh
echo 'Installing Mac App Store dependencies from brew...'
# Install only Mac App Store dependencies using Homebrew.
# Other dependencies are installed via MacPorts (see macports/install.sh).
brew bundle install
exit 0
