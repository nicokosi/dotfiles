alias brew-cask-info-versions='for x in `brew cask list`; do brew cask info $x 2>/dev/null | head -n 1; done'
alias brew-info-versions='for x in `brew list`; do brew info $x 2>/dev/null | head -n 1; done'
alias reload!='. ~/.zshrc'
