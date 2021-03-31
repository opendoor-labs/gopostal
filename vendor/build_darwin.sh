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
./bootstrap.sh
./configure
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
