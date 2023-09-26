#!/usr/bin/env bash

set -eu
set -o pipefail

echo "Installing dependencies..."
brew update
brew install curl autoconf automake libtool pkg-config

# Libpostal c package
echo "Cloning libpostal repo from github"
mkdir libpostal
git clone https://github.com/openvenues/libpostal libpostal

echo "Compiling package"
cd libpostal
git checkout v1.0.0
./bootstrap.sh
./configure
# Note: on M1 I had to use `arch -x64_86 make` and I had to patch the checkout with some additional includes
make
sudo make install

echo "Moving compiled files"
cp /usr/local/lib/libpostal.a libpostal_darwin.a
# We are not using the header file from darwin. We are only using the header
# file from linux as it contains less symbols (we don't need to use the language
# classifier).

# TODO: Clean up installed files.
rm -rf libpostal

echo "Successfully installed libpostal"
