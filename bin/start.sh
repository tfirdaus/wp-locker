#!/bin/bash

# shellcheck source=bin/shared.sh
source "$(dirname "$0")/shared.sh"

# Show a fancy banner \o/
banner

# Suppress banner from appearing.
export WP_LOCKER_BANNER=0

"$(dirname "$0")"/up.sh --build -d

while ! run cat wp-config.php > /dev/null 2>&1; do
	sleep 2
done

"$(dirname "$0")"/install.sh --wp-plugins --wp-themes "$@"

echo "👌 Done!"
