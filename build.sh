#!/bin/bash

# Simple build script for Evilginx2 Docker image
# Usage: ./build.sh [tag]

set -e

# Configuration
IMAGE_NAME="evilginx2"
DEFAULT_TAG="latest"
TAG=${1:-$DEFAULT_TAG}

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔨 Building Evilginx2 Docker image...${NC}"
echo -e "${GREEN}Image: ${IMAGE_NAME}:${TAG}${NC}"
echo ""

# Build the image
if docker build -t "${IMAGE_NAME}:${TAG}" .; then
    echo -e "${GREEN}✅ Build successful!${NC}"
    echo ""
    
    # Show image info
    echo -e "${GREEN}Image information:${NC}"
    docker images "${IMAGE_NAME}:${TAG}"
    echo ""
    
    # Show usage instructions
    echo -e "${YELLOW}Usage:${NC}"
    echo "docker run -it --rm -p 53:53/udp -p 80:80 -p 443:443 ${IMAGE_NAME}:${TAG}"
    echo ""
    echo -e "${YELLOW}Or use docker-compose:${NC}"
    echo "docker-compose up -d"
    echo ""
else
    echo -e "${RED}❌ Build failed!${NC}"
    exit 1
fi
