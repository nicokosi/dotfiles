set -x LSCOLORS "exfxcxdxbxegedabagacad"
set -x CLICOLOR true

set -U fish_history_max_size 10000

set -x EDITOR /usr/local/bin/subl
set -x VISUAL /usr/local/bin/subl

source /opt/local/share/fzf/shell/key-bindings.fish

zoxide init fish | source
