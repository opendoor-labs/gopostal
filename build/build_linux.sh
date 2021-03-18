#!/usr/bin/env bash

mkdir -p linux

docker build -t libpostal:latest .
container_id=$(docker create libpostal:latest)
docker cp "$container_id":/usr/local/include/libpostal/libpostal.h linux/libpostal.h
docker cp "$container_id":/usr/local/lib/libpostal.a linux/libpostal.a
docker rm "$container_id"
