#!/bin/sh

brew install zsh

# Install fonts for oh-my-git theme
wget -P $TMPDIR https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf
mv $TMPDIR/SourceCodePro+Powerline+Awesome+Regular.ttf /Library/Fonts/

git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search

exit 0
