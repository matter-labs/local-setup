#!/usr/bin/env bash

docker-compose down
rm -rf ./volumes
docker-compose pull
