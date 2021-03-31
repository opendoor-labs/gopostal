#!/usr/bin/env bash

docker build -t libpostal:latest .
container_id=$(docker create libpostal:latest)
docker cp "$container_id":/usr/local/include/libpostal/libpostal.h libpostal.h
docker cp "$container_id":/usr/local/lib/libpostal.a libpostal_linux.a
docker rm "$container_id"
