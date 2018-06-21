# (Re)install rustup
rustup-init -y

# Install 'rusti' Rust REPL
rustup run nightly-2016-08-01
rustup run nightly-2016-08-01 cargo install --git https://github.com/murarth/rusti

# Install 'rustfmt' Rust code formatter
rustup component add rustfmt-preview

# Install clippy, 'a bunch of lints to catch common mistakes and improve your Rust code'
rustup update nightly
rustup run nightly cargo install --force clippy
