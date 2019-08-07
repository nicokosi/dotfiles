# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# The rest of my fun git aliases
alias g='git'
alias ga='git add'
alias gap='git add -p'
alias gb='git branch --sort=committerdate'
alias gbr='git branch --remote --sort=committerdate'
alias gc='git commit'
alias gca='git commit -a'
alias gcb='git copy-branch-name'
alias gco='git checkout'
alias gd='git diff'
alias gf='git fetch'
alias gl='git pull --prune'
alias glo='git log --oneline --decorate --color'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gpf='git push --force-with-lease'
alias grh='git reset --hard @{u}'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gst='git status'
