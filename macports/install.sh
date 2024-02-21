#!/bin/zsh

echo-in-blue "Installing ports... ⤵️"
echo_and_run sudo port \
  -N `#Non-interactive mode` \
  install \
    bat \
    clojure \
    diff-so-fancy \
    diskonaut \
    fzf \
    gh \
    git \
    go \
    httpie \
    jenv \
    jq \
    leiningen \
    macos-trash \
    maven3 \
    mcfly \
    ncdu \
    npm10 \
    shellcheck \
    tealdeer \
    the_silver_searcher \
    tig \
    tree \
    youtube-dl \
    yt-dlp \
    zsh
echo-in-green "Ports have been installed! ☑️"
