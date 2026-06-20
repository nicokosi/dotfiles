set -x LSCOLORS "exfxcxdxbxegedabagacad"
set -x CLICOLOR true

set -U fish_history_max_size 10000

set -x EDITOR /usr/local/bin/subl
set -x VISUAL /usr/local/bin/subl

zoxide init fish | source
