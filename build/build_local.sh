#!/usr/bin/env bash

set -eu
set -o pipefail

echo "Installing dependencies..."
brew update
brew install curl autoconf automake libtool pkg-config

# Libpostal c package
echo "Cloning libpostal repo from github"
mkdir ~/libpostal
git clone https://github.com/openvenues/libpostal ~/libpostal

echo "Compiling package"
cd ~/libpostal
./bootstrap.sh
./configure
make
sudo make install

echo "Moving compiled files"
mkdir -p dev
cp /usr/local/lib/libpostal.a dev/libpostal.a
cp /usr/local/include/libpostal/libpostal.h dev/libpostal.h

echo "Successfully installed libpostal"