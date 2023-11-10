#!/bin/bash -x

cd "$(dirname "$0")"

export AWS_PROFILE="your-aws-profile"

aws secretsmanager put-secret-value \
    --secret-id "tableau-bridge-ecs-variables"\
    --secret-string file://../resources/variables.json \
    > /dev/null
