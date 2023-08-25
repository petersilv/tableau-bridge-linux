#!/bin/bash

cd "$(dirname "$0")"

# ----------------------------------------------------------------------------------------------------------------------
# Download Docker

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh && rm get-docker.sh

# ----------------------------------------------------------------------------------------------------------------------
# Build Postgres DB

docker pull postgres

docker run -d \
    --name postgres \
    -p 5432:5432 \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=password \
    -v ./data:/var/lib/postgresql/data \
    postgres

# ----------------------------------------------------------------------------------------------------------------------
# Add Sample DB

apt-get install unzip -y
wget -O dvdrental.zip https://www.postgresqltutorial.com/wp-content/uploads/2019/05/dvdrental.zip
unzip dvdrental.zip && rm dvdrental.zip

docker cp dvdrental.tar postgres:/dvdrental.tar

docker exec postgres psql -U postgres -c "CREATE DATABASE dvdrental"
docker exec postgres pg_restore -U postgres -d dvdrental /dvdrental.tar
