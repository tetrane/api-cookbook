#!/bin/bash

# Install rust
echo "Installing rust"
wget -O - https://sh.rustup.rs | sh -s -- -y -q

# Install rust dependencies
echo "Installing mdbook"
source $HOME/.cargo/env
cargo install --version "0.4.13" mdbook
cargo install --version "0.4.0" mdbook-tera
