#!/bin/bash

cd "$(dirname "$0")"

# Set Variables
export AWS_PROFILE="your-aws-profile"
export AWS_REGION="your-aws-region"

docker_image_tag="tableau-bridge:latest"
aws_account_id=$(aws sts get-caller-identity | jq -r '.Account')
ecr_repository_uri="${aws_account_id}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# Login to ECR
aws ecr get-login-password | docker login --username AWS --password-stdin $ecr_repository_uri

# Build Image
docker build --platform=linux/amd64 --tag $docker_image_tag ../resources

# Push image to ECR
docker_image_id=$(docker images -q $docker_image_tag)
docker tag $docker_image_id "${ecr_repository_uri}/${docker_image_tag}"
docker push "${ecr_repository_uri}/${docker_image_tag}"
