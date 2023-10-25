#!/bin/bash

cd "$(dirname "$0")"

# ----------------------------------------------------------------------------------------------------------------------
# Install Docker

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh && rm get-docker.sh

# ----------------------------------------------------------------------------------------------------------------------
# Download Bridge Installer

wget -O bridge.rpm https://downloads.tableau.com/tssoftware/TableauBridge-20233.23.1017.0948.x86_64.rpm

# ----------------------------------------------------------------------------------------------------------------------
# Build Bridge Container and start Bridge

docker image build -t bridge ./

docker run -d \
    --name bridge \
    --env-file ./variables \
    bridge
