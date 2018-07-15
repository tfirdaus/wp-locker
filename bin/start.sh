#!/bin/bash

# shellcheck source=bin/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

export WP_LOCKER_START=1

"$(dirname "$0")"/up.sh --build -d

while ! dexec cat wp-config.php > /dev/null 2>&1; do
	sleep 2
done

"$(dirname "$0")"/install.sh --wp-plugins --wp-themes "$@"

echo "👌 Done!"
