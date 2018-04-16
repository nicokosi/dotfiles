# Install rust
curl https://sh.rustup.rs -sSf | sh

rustup update

# Install rustfmt
rustup component add rustfmt-preview

# Install rusti
apt install libncursesw5-dev
rustup install nightly-2016-08-01
rustup run nightly-2016-08-01 cargo install --git https://github.com/murarth/rusti

