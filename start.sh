#!/usr/bin/env bash

mkdir -p ./volumes
mkdir -p ./volumes/postgres ./volumes/geth

docker-compose up
