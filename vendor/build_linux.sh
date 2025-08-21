#!/usr/bin/env bash

# To build the static libpostal library for Linux, we use a Docker container.
# You can use a MacBook with Apple Silicon to build the library for linux/arm64,
# and RDI Ubuntu instances to build the library for linux/amd64.
if [ "$(uname -m)" = "arm64" ]; then ARCH="arm64"; else ARCH="amd64"; fi
echo "Building libpostal for linux/$ARCH platform"

docker build --platform linux/$ARCH --load -t libpostal:$ARCH .
container_id=$(docker create libpostal:$ARCH)
docker cp "$container_id":/usr/local/include/libpostal/libpostal.h libpostal.h
docker cp "$container_id":/usr/local/lib/libpostal.a libpostal_linux_$ARCH.a
docker rm "$container_id"
