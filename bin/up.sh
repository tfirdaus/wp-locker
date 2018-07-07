#!/bin/bash

# shellcheck source=bin/shared.sh
source "$(dirname "$0")/shared.sh"

PARAMS=""
if [ -z "$*" ]; then
    PARAMS="--build"
fi

# Show a fancy banner \o/
banner

# Build containers
echo "🔄 Spinning up containers."
if [ -e "docker-custom.yml" ]; then
	docker-compose -f docker-compose.yml -f docker-custom.yml up ${PARAMS} "$@"
else
    docker-compose up ${PARAMS} "$@"
fi
