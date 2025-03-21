#!/usr/bin/env bash

# usage: ./start-zk-chains.sh INSTANCE_TYPE
# Instance type is specifying the docker image to take:
# see https://hub.docker.com/r/matterlabs/local-node/tags for full list.
# latest2.0 - is the 'main' one.

INSTANCE_TYPE=${1:-latest2.0}
export INSTANCE_TYPE=$INSTANCE_TYPE

# Fetch the latest images and start all services
docker compose -f zk-chains-docker-compose.yml pull
docker compose -f zk-chains-docker-compose.yml up -d zksync

echo "Waiting for zkSync master node to be ready..."
until curl --fail http://localhost:15102/health; do
  echo "zkSync not ready yet, sleeping..."
  sleep 10
done

echo "zkSync is ready. Waiting for token deployment..."
until docker exec local-setup-zksync-1 test -f /configs/erc20.yaml; do
  echo "Token config file not found yet, checking again in 5 seconds..."
  sleep 5
done

echo "Extracting deployed token address from inside zksync container..."
CUSTOM_TOKEN_ADDRESS=$(docker exec local-setup-zksync-1 awk -F": " '/tokens:/ {found_tokens=1} found_tokens && /WBTC:/ {found_dai=1} found_dai && /address:/ {print $2; exit}' /configs/erc20.yaml)

if [ -z "$CUSTOM_TOKEN_ADDRESS" ]; then
  echo "❌ Error: Could not retrieve token address. Exiting."
  exit 1
fi

echo "✅ CUSTOM_TOKEN_ADDRESS=$CUSTOM_TOKEN_ADDRESS"

# ✅ Write to .env for docker-compose
echo "CUSTOM_TOKEN_ADDRESS=$CUSTOM_TOKEN_ADDRESS" > .env

# ✅ Restart zksync_custombase with the correct value
docker compose -f zk-chains-docker-compose.yml up -d zksync_custombase

echo "✅ zksync_custombase started with CUSTOM_BASE_TOKEN=$CUSTOM_TOKEN_ADDRESS"

# Ensure all services are running
echo "Starting all services..."
docker compose -f zk-chains-docker-compose.yml up -d

# Function to check if all services are healthy
check_all_services_healthy() {
  services=("zksync" "zksync_custombase")
  all_healthy=true

  for service in "${services[@]}"; do
    echo "Checking service: $service"
    
    # Print current service status for debugging
    docker compose -f zk-chains-docker-compose.yml ps "$service"

    # Check if service is healthy
    if ! docker compose -f zk-chains-docker-compose.yml ps "$service" | grep -q "(healthy)"; then
      all_healthy=false
      echo "❌ Service $service is NOT healthy! Fetching logs ..."

      docker compose -f zk-chains-docker-compose.yml logs "$service"

      # Check if container has exited
      if docker compose -f zk-chains-docker-compose.yml ps "$service" | grep -q "Exit"; then
        echo "🚨 Service $service has exited unexpectedly. Fetching logs..."
        docker compose -f zk-chains-docker-compose.yml logs "$service"
        exit 1  # Stop execution if a service fails
      fi
    else
      echo "✅ Service $service is healthy."
    fi
  done

  $all_healthy && return 0 || return 1
}

# Loop until all services are healthy or a failure is detected
until check_all_services_healthy; do
  echo "Services are not yet healthy, waiting..."
  sleep 10
done

GREEN='\033[0;32m'
BLUE='\033[0;34m'
DARKGRAY='\033[0;30m'
ORANGE='\033[0;33m'
echo -e "${GREEN}"

echo -e "SUCCESS, Your local ZK Chains are now running! Find the information below for accessing each service."
echo -e ""
echo -e "-> ZK Chain1 (Master) is a normal zkSync Node"
echo -e "-> ZK Chain2 (CustomBase) is a ZK Chain with a custom base token (BAT)"
echo -e ""
echo -e "┌──────────────────────────┬────────────────────────┬──────────────────────────────────────────────────┐"
echo -e "│         Service          │          URL           │                   Description                    │"
echo -e "├──────────────────────────┼────────────────────────┼──────────────────────────────────────────────────┤"
echo -e "│ ${ORANGE}HyperExplorer            ${GREEN}│ ${BLUE}http://localhost:15000${GREEN} │ ${DARKGRAY}Explorer for communication between ZK Chains     ${GREEN}│"
echo -e "│ ${ORANGE}L1 Explorer              ${GREEN}│ ${BLUE}http://localhost:15001${GREEN} │ ${DARKGRAY}Block Explorer for Layer 1 (reth)                ${GREEN}│"
echo -e "│ ${ORANGE}L2 Explorer (All Chains) ${GREEN}│ ${BLUE}http://localhost:15005${GREEN} │ ${DARKGRAY}Block Explorer for all L2 ZK Chains              ${GREEN}│"
echo -e "│ ${ORANGE}L1 Chain (reth)          ${GREEN}│ ${BLUE}http://localhost:15045${GREEN} │ ${DARKGRAY}Endpoint for L1 reth node                        ${GREEN}│"
echo -e "│ ${ORANGE}ZK Chain1                ${GREEN}│ ${BLUE}http://localhost:15100${GREEN} │ ${DARKGRAY}HTTP Endpoint for L2 ZK Chain1                   ${GREEN}│"
echo -e "│ ${ORANGE}                         ${GREEN}│ ${BLUE}ws://localhost:15101${GREEN}   │ ${DARKGRAY}Websocket Endpoint for L2 ZK Chain1              ${GREEN}│"
echo -e "│ ${ORANGE}                         ${GREEN}│ ${BLUE}http://localhost:15102${GREEN} │ ${DARKGRAY}ZK Chain1 Explorer API                           ${GREEN}│"
echo -e "│ ${ORANGE}ZK Chain2                ${GREEN}│ ${BLUE}http://localhost:15200${GREEN} │ ${DARKGRAY}HTTP Endpoint for L2 ZK Chain2                   ${GREEN}│"
echo -e "│ ${ORANGE}                         ${GREEN}│ ${BLUE}ws://localhost:15201${GREEN}   │ ${DARKGRAY}Websocket Endpoint for L2 ZK Chain2              ${GREEN}│"
echo -e "│ ${ORANGE}                         ${GREEN}│ ${BLUE}http://localhost:15202${GREEN} │ ${DARKGRAY}ZK Chain2 Explorer API                           ${GREEN}│"
echo -e "│ ${ORANGE}pgAdmin                  ${GREEN}│ ${BLUE}http://localhost:15430${GREEN} │ ${DARKGRAY}UI to manage the PostgreSQL databases            ${GREEN}│"
echo -e "│ ${ORANGE}PostgreSQL DB Server     ${GREEN}│ ${BLUE}http://localhost:15432${GREEN} │ ${DARKGRAY}Database server for all services running locally ${GREEN}│"
echo -e "└──────────────────────────┴────────────────────────┴──────────────────────────────────────────────────┘"