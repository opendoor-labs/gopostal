#!/usr/bin/env bash

if [ "$(uname -m)" = "arm64" ]; then ARCH="arm64"; else ARCH="amd64"; fi
echo "Building libpostal for linux/$ARCH platform"

docker build --platform linux/$ARCH --load -t libpostal:$ARCH .
container_id=$(docker create libpostal:$ARCH)
docker cp "$container_id":/usr/local/include/libpostal/libpostal.h libpostal.h
docker cp "$container_id":/usr/local/lib/libpostal.a libpostal_linux_$ARCH.a
docker rm "$container_id"
