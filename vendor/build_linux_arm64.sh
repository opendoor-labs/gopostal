#!/usr/bin/env bash

docker build --platform linux/arm64 --load -t libpostal:arm64 .
container_id=$(docker create --platform linux/arm64 libpostal:arm64)
docker cp "$container_id":/usr/local/lib/libpostal.a libpostal_linux_arm64.a
docker rm "$container_id"