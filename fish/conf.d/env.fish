# SSH: load keys from macOS Keychain silently (avoids passphrase prompts)
ssh-add -A 2>/dev/null

# macOS system preferences
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.dock autohide -bool true
defaults write com.apple.finder AppleShowAllFiles 1

# PATH additions
fish_add_path ./bin /usr/local/bin /usr/local/sbin $ZSH/bin
fish_add_path $HOME/.npm-global/bin
fish_add_path /usr/local/opt/trash/bin
fish_add_path $HOME/Library/Haskell/bin

# Go
set -x GOPATH $HOME/work/gocode
fish_add_path $GOPATH/bin /usr/local/go/bin

# Groovy
set -x GROOVY_HOME /usr/local/opt/groovy/libexec

# Volta
set -x VOLTA_HOME $HOME/.volta
fish_add_path $VOLTA_HOME/bin

# Homebrew
set -x HOMEBREW_VERIFY_ATTESTATIONS false

# fzf: respect .gitignore
set -x FZF_DEFAULT_COMMAND 'fd --type file'

# mcfly
set -x MCFLY_FUZZY 2

# Private env vars (stash secrets in ~/.env-vars, outside this repo)
if test -f ~/.env-vars
    source ~/.env-vars
end
