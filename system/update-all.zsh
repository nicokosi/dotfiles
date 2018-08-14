echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}${2}${NO_COLOR}"
}
echo-in-blue() { echo-in "\033[0;34m" $1}
echo-in-green() { echo-in "\033[0;92m" $1}

update-all() {
	echo-in-blue "Homebrew updates..."
	brew-upgrades
	echo-in-green "Homebrew updates done!"
	
	echo-in-blue "JDK updates..."
	sdk selfupdate
	sdk update java
	echo-in-green "JDK updates done!"

	echo-in-blue "Rustup updates..."
	rustup update
	echo-in-green "Rustup updates done!"
}

