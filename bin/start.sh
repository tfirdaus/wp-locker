#!/bin/bash

# shellcheck source=src/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

# Show a fancy banner \o/
banner

# Suppress banner from appearing.
export WP_LOCKER_BANNER=0
export WP_LOCKER_START=1

"$(dirname "$0")"/up.sh --build -d

while ! drun cat wp-config.php > /dev/null 2>&1; do
	sleep 2
done

"$(dirname "$0")"/install.sh --wp-plugins --wp-themes "$@"

echo "👌 Done!"
