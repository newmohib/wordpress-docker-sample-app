#!/bin/bash

# Check if the "src" folder is empty or not
if [ ! "$(ls -A ./src)" ]; then
    echo "Cloning WordPress source code..."
    git clone https://github.com/WordPress/WordPress.git ./src
else
    echo "WordPress source already exists in ./src"
fi

# Build the Docker image
echo "Building the custom WordPress Docker image..."
docker-compose build

# Start the containers
echo "Starting Docker containers..."
docker-compose up -d
