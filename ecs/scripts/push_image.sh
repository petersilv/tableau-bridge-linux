#!/bin/bash

cd "$(dirname "$0")"

# Set Variables
export AWS_PROFILE="your-aws-profile"
export AWS_REGION="your-aws-region"
export BRIDGE_INSTALLER_URL="https://downloads.tableau.com/tssoftware/TableauBridge-20233.23.1017.0948.x86_64.rpm"
export POSTGRES_DRIVER_URL="https://jdbc.postgresql.org/download/postgresql-42.6.0.jar"

docker_image_tag="tableau-bridge:latest"
aws_account_id=$(aws sts get-caller-identity | jq -r '.Account')
ecr_repository_uri="${aws_account_id}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Login to ECR
aws ecr get-login-password | docker login --username AWS --password-stdin $ecr_repository_uri

# Build Image
wget -O ../resources/bridge.rpm $BRIDGE_INSTALLER_URL
wget -O ../resources/postgresql.jar $POSTGRES_DRIVER_URL
docker build --platform=linux/amd64 --tag $docker_image_tag ../resources

# Push image to ECR
docker_image_id=$(docker images -q $docker_image_tag)
docker tag $docker_image_id "${ecr_repository_uri}/${docker_image_tag}"
docker push "${ecr_repository_uri}/${docker_image_tag}"
