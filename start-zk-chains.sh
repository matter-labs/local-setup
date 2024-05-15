#!/usr/bin/env bash

# usage: ./start-zk-chains.sh INSTANCE_TYPE 
# Instance type is specifying the docker image to take:
# see https://hub.docker.com/r/matterlabs/local-node/tags for full list.
# latest2.0 - is the 'main' one.

INSTANCE_TYPE=${1:-latest2.0}
export INSTANCE_TYPE=$INSTANCE_TYPE

# Fetch the latest images
docker compose -f zk-chains-docker-compose.yml pull
docker compose -f zk-chains-docker-compose.yml up -d

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

GREEN='\033[0;32m'
BLUE='\033[0;34m'
DARKGRAY='\033[0;30m'
ORANGE='\033[0;33m'
echo -e "${GREEN}"

echo -e "SUCCESS, Your local ZK Chains are now running! Find the information below for accessing each service."
echo -e ""
echo -e "-> ZK Chain1 (Master) is a normal zkSync Node"
echo -e "-> ZK Chain2 (CustomBase) is a ZK Chain with a custom base token (BAT)"
echo -e "-> ZK Chain3 (Validium) is a ZK Chain running in Validium mode"
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
echo -e "│ ${ORANGE}ZK Chain3                ${GREEN}│ ${BLUE}http://localhost:15300${GREEN} │ ${DARKGRAY}Endpoints for L2 ZK Chain3                       ${GREEN}│"
echo -e "│ ${ORANGE}                         ${GREEN}│ ${BLUE}ws://localhost:15301${GREEN}   │ ${DARKGRAY}Websocket Endpoint for L2 ZK Chain3              ${GREEN}│"
echo -e "│ ${ORANGE}                         ${GREEN}│ ${BLUE}http://localhost:15302${GREEN} │ ${DARKGRAY}ZK Chain3 Explorer API                           ${GREEN}│"
echo -e "│ ${ORANGE}pgAdmin                  ${GREEN}│ ${BLUE}http://localhost:15430${GREEN} │ ${DARKGRAY}UI to manage the PostgreSQL databases            ${GREEN}│"
echo -e "│ ${ORANGE}PostgreSQL DB Server     ${GREEN}│ ${BLUE}http://localhost:15432${GREEN} │ ${DARKGRAY}Database server for all services running locally ${GREEN}│"
echo -e "└──────────────────────────┴────────────────────────┴──────────────────────────────────────────────────┘"