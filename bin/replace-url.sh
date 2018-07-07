#!/bin/bash

# shellcheck source=bin/shared.sh
source "$(dirname "$0")/shared.sh"

if [[ -z "$1" ]]; then
	echo "⛔️ Usage: $0 <new-url>"
	exit 1
fi

replace_urls $1
