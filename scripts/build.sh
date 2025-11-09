#!/bin/bash

# Build and push Docker image
# Usage: ./build.sh [tag]

set -e

IMAGE_REPO="ghcr.io/nathan47293/blackjack-devops-ia"
TAG="${1:-latest}"
FULL_IMAGE="$IMAGE_REPO:$TAG"

echo "Building Docker Image"
echo "========================"
echo "Image: $FULL_IMAGE"
echo ""

# Build the image
echo "Building image..."
docker build -t $FULL_IMAGE .

# Tag with latest if not already latest
if [ "$TAG" != "latest" ]; then
    docker tag $FULL_IMAGE $IMAGE_REPO:latest
fi

# Push to registry
echo "Pushing to registry..."
docker push $FULL_IMAGE

if [ "$TAG" != "latest" ]; then
    docker push $IMAGE_REPO:latest
fi

echo ""
echo "Build and push completed successfully!"
echo "Image: $FULL_IMAGE"