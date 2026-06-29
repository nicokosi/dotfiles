abbr -a g git
abbr -a ga git add
abbr -a gap git add -p
abbr -a gbr git branch --remote
abbr -a gc git commit
abbr -a gco git checkout
abbr -a gcp git cherry-pick
abbr -a gd git diff
abbr -a gf git fetch
abbr -a gl git pull
abbr -a glo git log --oneline
abbr -a gp git push
abbr -a gpf git push --force-with-lease
abbr -a gr git rebase
abbr -a gst git status
abbr -a l eza
abbr -a open xdg-open
function apt-all-upgrades
    sudo apt update && sudo apt upgrade && sudo apt-get autoremove
end
function upgrade-everything
  apt-all-upgrades && brew upgrade && mise upgrade && gh extension upgrade --all
end
