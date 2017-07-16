# grc overides for ls
#   Made possible through contributions from generous benefactors like
#   `brew install coreutils`
if $(gls &>/dev/null)
then
  alias ls="gls -F --color"
  alias l="gls -lAh --color"
  alias ll="gls -l --color"
  alias la='gls -A --color'
fi


alias upgrade="echo '\033[0;34mUpgrade shell (oh my zsh) and apps (via brew)\033[0m' && antigen update && brew-upgrades"
