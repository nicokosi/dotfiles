#!/bin/zsh

echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}$@[2,$#]${NO_COLOR}"
}

echo-in-light-cyan() { echo-in "\033[0;96m" $*}
echo-in-blue() { echo-in "\033[0;34m" $*}
echo-in-green() { echo-in "\033[0;92m" $*}

echo_and_run() { echo-in-light-cyan "$*" ; "$@" ; }