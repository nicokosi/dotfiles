echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}${2}${NO_COLOR}"
}
echo-in-light-cyan() { echo-in "\033[0;96m" $1}

update-all() {
 	echo-in-light-cyan "Homebrew updates..."
	brew-upgrades
  echo "Homebrew updates done!"

	echo-in-light-cyan "JDK updates..."
	sdk selfupdate
	sdk update java
	echo "JDK updates done!"

	echo-in-light-cyan "Rustup updates..."
	rustup update
	echo "Rustup updates done!"
}
