#!/usr/bin/env bash

mkdir -p ./volumes
mkdir -p ./volumes/postgres ./volumes/geth ./volumes/zksync/env/dev ./volumes/zksync/data

docker-compose up

