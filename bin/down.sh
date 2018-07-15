#!/bin/bash

# Stop and remove containers
echo -e "\\n⛔️ Stopping and removing containers..."
docker-compose down "$@"
echo "👌 Done!"
