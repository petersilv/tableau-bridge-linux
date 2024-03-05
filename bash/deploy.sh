#!/bin/bash

cd "$(dirname "$0")"

apt-get update && \
apt-get upgrade -y

# ------------------------------------------------------------------------------
# Check for required files
if [ ! -f "Dockerfile" ]; then
    echo "Dockerfile is missing, exiting..."
    exit 1
fi

if [ ! -f "variables.sh" ]; then
    echo "variables.sh file is missing, exiting..."
    exit 1
fi

# ------------------------------------------------------------------------------
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh && rm get-docker.sh

# ------------------------------------------------------------------------------
# Build Bridge Container and start Bridge
source ./variables.sh

docker image build \
    --tag bridge \
    --network host \
    --build-arg BRIDGE_INSTALLER=$BRIDGE_INSTALLER \
    --build-arg POSTGRES_DRIVER=$POSTGRES_DRIVER \
    ./

docker run \
    --name $CLIENT \
    --network host \
    --env-file ./variables.sh \
    --volume /opt/bridge/logs:/root/Documents/My_Tableau_Bridge_Repository/Logs \
    --detach \
    bridge

rm ./variables.sh