echo-in() { #args= color, text
  local NO_COLOR="\033[0m"
  echo "${1}${2}${NO_COLOR}"
}
echo-in-light-cyan() { echo-in "\033[0;96m" $1}

update-all() {

	echo-in-light-cyan "Update Antigen (shell plugins)..."
	antigen selfupdate
	antigen update
	echo "Antigen updated!"

	echo-in-light-cyan "Update Homebrew (applications)..."
	brew-upgrades
	echo "Homebrew updated!"

	echo-in-light-cyan "Update Java env..."
	sdk selfupdate
	sdk update java
	echo "Java env updated!"

	echo-in-light-cyan "Update Rust env..."
	rustup update
	echo "Rust env updated!"
}
