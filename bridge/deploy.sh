#!/bin/bash

cd "$(dirname "$0")"

# ----------------------------------------------------------------------------------------------------------------------
# Install Docker

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh && rm get-docker.sh

# ----------------------------------------------------------------------------------------------------------------------
# Build Bridge Container and start Bridge

wget https://raw.githubusercontent.com/petersilv/tableau-bridge-linux/main/bridge/Dockerfile

docker image build -t bridge ./

docker run -d \
    --name bridge \
    --env-file ./variables \
    bridge
