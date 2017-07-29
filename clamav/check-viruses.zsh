echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}${2}${NO_COLOR}"
}
echo-in-blue() { echo-in "\033[0;34m" $1}
echo-in-green() { echo-in "\033[0;92m" $1}

check-viruses() {

  echo-in-blue "Upgrading virus definitions..."
  freshclam

  if [ ! -z "$1" ]; then
    echo-in-blue "Scanning $1..."
    clamscan --bell --infected --recursive $1
    echo-in-green "Analyzed folder $1"
  else
    echo-in-blue "Scanning root dir..."
    for folder in `find / -maxdepth 1 -type d -print | grep -v "^/$"`
    do
      clamscan --bell --infected --recursive $folder
      echo-in-green "Analyzed folder $folder"
    done
  fi
  echo-in-green "Done!"
}
