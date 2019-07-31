# (Re)install rustup
rustup-init -y

# Install 'rustfmt' Rust code formatter
rustup component add rustfmt

# Install clippy, 'a bunch of lints to catch common mistakes and improve your Rust code'
rustup update
rustup component add clippy-preview
