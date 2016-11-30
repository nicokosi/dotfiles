#!/usr/bin/env bash

# Disable the sound effects on boot
#sudo nvram SystemAudioVolume=" "

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true