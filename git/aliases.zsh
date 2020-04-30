# Use `hub` as our git wrapper:
#   http://defunkt.github.com/hub/
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi

# The rest of my fun git aliases
alias gl='git pull --prune'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gp='git push origin HEAD'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gcb='git copy-branch-name'
alias gb='git branch --sort=committerdate'
alias gbr='git branch --remote --sort=committerdate'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gap="git add --patch"

alias gst="git status"
alias glo="git log"
alias gr="git rebase"
alias gcp="git cherry-pick"
alias gpf='git push --force-with-lease'
alias git-delete-merged-local-branches="git branch -d \$(git branch --merged | grep -v '^*' | grep -v 'master' | tr -d '\n')"
alias git-audit-all-github-repos="audit"
alias git-protect-github-branches="protector"

alias mg="parallel-git-repo"
alias pgr=mg
alias g="git"