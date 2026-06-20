#!/bin/zsh

~/.dotfiles/system/echos.zsh

update-all() {
	echo-in-blue "Update Homebrew (applications)..."
	echo_and_run brew-upgrades
	echo-in-green "Homebrew updated!"

	echo-in-blue "Update MacPorts (applications)..."
	echo_and_run macports-upgrades
	echo-in-green "MacPorts updated!"

	echo-in-blue "Update Rust env..."
	echo_and_run rustup update
	echo "Rust env updated!"


}
