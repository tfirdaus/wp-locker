#!/bin/bash

# shellcheck source=bin/shared.sh
source "$(dirname "$0")/shared.sh"

# Show a fancy banner \o/
banner

# Stop and remove containers
echo "⛔️ Stopping and removing containers..."
docker-compose down "$@"
echo "👌 Done!"
