#!/bin/bash

# shellcheck source=bin/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

while IFS= read -r line; do
	export "$(echo -e "$line" | sed -e 's/[[:space:]]*$//' -e "s/'//g")"
done < <(grep WP_ .env)

PARAMS=""
if [ -z "$*" ]; then
    PARAMS="--build"
fi

# Build containers
echo -e "\\n🔄 Spinning up containers."
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
