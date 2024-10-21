#!/bin/bash

DOCKER_HUB_USERNAME="newmohib"  # Replace with your Docker Hub username
IMAGE_NAME="custom_wordpress"  # Name for the custom Docker image
BACKUP_IMAGE_NAME="${IMAGE_NAME}_backup_$(date +%Y%m%d%H%M%S)"  # Backup image name with timestamp
CONTAINER_NAME="wordpress_container"  # Name for the running WordPress container
IMAGE_TAG="latest"

# Function to stop and remove the Docker container if it exists
function stop_and_remove_container() {
    if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
        echo "Stopping and removing the existing container: $CONTAINER_NAME..."
        docker stop $CONTAINER_NAME
        docker rm $CONTAINER_NAME
        echo "Container $CONTAINER_NAME has been stopped and removed."
    else
        echo "No existing container named $CONTAINER_NAME found."
    fi
}

# Function to backup and remove the Docker image if it exists
function backup_and_remove_docker_image() {
    if docker image inspect $IMAGE_NAME > /dev/null 2>&1; then
        echo "Docker image $IMAGE_NAME already exists. Creating a backup..."
        docker tag $IMAGE_NAME $BACKUP_IMAGE_NAME
        echo "Backup created as $BACKUP_IMAGE_NAME"
        
        # Now remove the original image
        echo "Removing the original Docker image: $IMAGE_NAME..."
        docker rmi $IMAGE_NAME
        echo "Docker image $IMAGE_NAME has been removed."
    else
        echo "No existing Docker image named $IMAGE_NAME found. Proceeding without backup."
    fi
}

# Function to run the backup image if the new build fails
function run_backup_image() {
    echo "Attempting to run the backup image..."
    if docker image inspect $BACKUP_IMAGE_NAME > /dev/null 2>&1; then
        # Start the container using the backup image
        echo "Starting container with backup image: $BACKUP_IMAGE_NAME..."
        docker run -d --name $CONTAINER_NAME $BACKUP_IMAGE_NAME
        echo "Container is running with backup image."
    else
        echo "Backup image $BACKUP_IMAGE_NAME does not exist. Unable to revert."
    fi
}

# Function to push the new Docker image to Docker Hub
function push_to_docker_hub() {
    echo "Tagging the new image for Docker Hub..."
    docker tag $IMAGE_NAME:${IMAGE_TAG} ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}

    echo "Pushing the new image to Docker Hub..."
    if docker push ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}; then
        echo "New image successfully pushed to Docker Hub: ${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}"
    else
        echo "Failed to push the new image to Docker Hub."
    fi
}

# Function to check if the new image differs from the backup image
function check_image_difference() {
    NEW_IMAGE_DIGEST=$(docker image inspect --format='{{index .RepoDigests 0}}' $IMAGE_NAME)
    BACKUP_IMAGE_DIGEST=$(docker image inspect --format='{{index .RepoDigests 0}}' $BACKUP_IMAGE_NAME 2>/dev/null)

    if [ "$NEW_IMAGE_DIGEST" != "$BACKUP_IMAGE_DIGEST" ]; then
        echo "The new image is different from the backup image."
        push_to_docker_hub
    else
        echo "The new image is identical to the backup image. No need to push."
    fi
}

# Check if the "src" folder is empty or not
if [ ! "$(ls -A ./src)" ]; then
    echo "Cloning WordPress source code..."
    git clone https://github.com/WordPress/WordPress.git ./src
else
    echo "WordPress source already exists in ./src"
fi

# Stop and remove the existing container, if any
stop_and_remove_container

# Backup the existing Docker image, then remove it
backup_and_remove_docker_image

# Build the Docker image
echo "Building the custom WordPress Docker image..."
if docker-compose build; then
    echo "Build succeeded as new Image: $IMAGE_NAME. Starting the containers..."
    docker-compose up -d

    # Check if the new image is different from the backup image before pushing to Docker Hub
    check_image_difference
else
    echo "Build failed. Reverting to the backup image..."
    # Run the backup image if the build failed
    run_backup_image
fi
