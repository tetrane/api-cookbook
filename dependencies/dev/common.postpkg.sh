#!/bin/bash

# Install rust
echo "Installing rust"
wget -O - https://sh.rustup.rs | sh -s -- -y -q

# Install rust dependencies
echo "Installing mdbook"
source $HOME/.cargo/env
cargo install mdbook
