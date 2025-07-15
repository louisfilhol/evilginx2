#!/bin/sh

# Evilginx2 Docker Startup Script
# This script helps with initial configuration and startup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CONFIG_DIR=${EVILGINX_CONFIG_DIR:-/app/data}
PHISHLETS_DIR=${EVILGINX_PHISHLETS_DIR:-/app/phishlets}
REDIRECTORS_DIR=${EVILGINX_REDIRECTORS_DIR:-/app/redirectors}

# Create necessary directories
mkdir -p "$CONFIG_DIR"
mkdir -p "$CONFIG_DIR/crt"

# Check if running as root (not recommended)
if [ "$(id -u)" -eq 0 ]; then
    echo -e "${YELLOW}Warning: Running as root is not recommended for security reasons${NC}"
fi

# Display startup information
echo -e "${GREEN}🚀 Starting Evilginx2...${NC}"
echo -e "${GREEN}Configuration directory: ${CONFIG_DIR}${NC}"
echo -e "${GREEN}Phishlets directory: ${PHISHLETS_DIR}${NC}"
echo -e "${GREEN}Redirectors directory: ${REDIRECTORS_DIR}${NC}"
echo ""

# Check if phishlets directory exists and has files
if [ ! -d "$PHISHLETS_DIR" ] || [ -z "$(ls -A "$PHISHLETS_DIR")" ]; then
    echo -e "${YELLOW}Warning: Phishlets directory is empty or doesn't exist${NC}"
    echo -e "${YELLOW}Make sure to add phishlet files to continue${NC}"
fi

# Check if redirectors directory exists
if [ ! -d "$REDIRECTORS_DIR" ]; then
    echo -e "${YELLOW}Warning: Redirectors directory doesn't exist${NC}"
    mkdir -p "$REDIRECTORS_DIR"
fi

# Display important security notice
echo -e "${RED}⚠️  SECURITY NOTICE ⚠️${NC}"
echo -e "${RED}This tool is for authorized penetration testing only!${NC}"
echo -e "${RED}Unauthorized use may be illegal in your jurisdiction.${NC}"
echo ""

# Container ready for manual execution
echo -e "${GREEN}Container is ready!${NC}"
echo -e "${GREEN}To start Evilginx2, run:${NC}"
echo "./evilginx -c \"$CONFIG_DIR\" -p \"$PHISHLETS_DIR\" -t \"$REDIRECTORS_DIR\""
echo ""
echo -e "${GREEN}Or use the environment variables:${NC}"
echo "EVILGINX_CONFIG_DIR=$CONFIG_DIR"
echo "EVILGINX_PHISHLETS_DIR=$PHISHLETS_DIR"
echo "EVILGINX_REDIRECTORS_DIR=$REDIRECTORS_DIR"
echo ""

# Keep container running
exec tail -f /dev/null
