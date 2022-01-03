#!/bin/bash

# Install mdbook binaries
echo "Installing mdbook"
wget -O - https://github.com/rust-lang/mdBook/releases/download/v0.4.14/mdbook-v0.4.14-x86_64-unknown-linux-gnu.tar.gz | tar xvzf -
echo "Installing mdbook-tera"
wget -O - https://github.com/avitex/mdbook-tera/releases/download/v0.4.2/mdbook-tera-x86_64-unknown-linux-gnu.tar.gz | tar xvzf -

