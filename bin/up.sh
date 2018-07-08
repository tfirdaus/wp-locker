#!/bin/bash

# shellcheck source=bin/shared.sh
source "$(dirname "$0")/shared.sh"

while IFS= read -r line; do
	export "$(echo -e "$line" | sed -e 's/[[:space:]]*$//' -e "s/'//g")"
done < <(cat .env | grep WP_) # Get the "WP_" variables.

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

# If it is initiated directly.
if [ -z "$WP_LOCKER_START" ]; then
	WP_SITE_URL="http://${WP_SITE_DOMAIN}:${WP_PUBLISHED_PORT}"

	echo -e "WordPress is not yet installed.\\nLoad the site URL to get started."
	echo "Your site URL: ${WP_SITE_URL}${WP_SITE_SUBDIR}"
fi
