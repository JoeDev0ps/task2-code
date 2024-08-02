#!/bin/bash

# Remove running containers (cleanup)
docker rm -f $(docker ps -q -a)

# Create a network
docker network create mynetwork

# Create a volume
docker volume create myvolume

# Build flask-app + mysql images
docker build -t flask-app flask-app
docker build -t mysql db

# Run mysql container
docker run -d \
    --name mysql \
    --network mynetwork \
    --mount type=volume,source=myvolume,target=/var/lib/mysql \
    mysql

# Run flask container
docker run -d \
    -e MYSQL_ROOT_PASSWORD=secretpass \
    --name flask-app \
    --network mynetwork \
    flask-app

# Run nginx container (official image)
docker run -d \
    --name nginx \
    -p 80:80 \
    --network mynetwork \
    --mount type=bind,source=$(pwd)/nginx/nginx.conf,target=/etc/nginx/nginx.conf \
    nginx

# Show all containers
docker ps -a
