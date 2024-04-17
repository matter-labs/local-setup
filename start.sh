#!/usr/bin/env bash
# docker compose up -d

# usage: ./start.sh INSTANCE_TYPE 
# Instance type is specifying the docker image to take:
# see https://hub.docker.com/r/matterlabs/local-node/tags for full list.
# latest2.0 - is the 'main' one.

INSTANCE_TYPE=${1:-latest2.0}

export INSTANCE_TYPE=$INSTANCE_TYPE
docker compose up -d


check_all_services_healthy() {
  service="zksync"
  (docker compose ps $service | grep "(healthy)")
  if [ $? -eq 0 ]; then
    return 0
  else
    return 1  # If any service is not healthy, return 1
  fi
}


# Loop until all services are healthy
while ! check_all_services_healthy; do
  echo "Services are not yet healthy, waiting..."
  sleep 10  # Check every 10 seconds
done

echo "All services are healthy!"