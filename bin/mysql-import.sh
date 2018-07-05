#!/bin/bash

# shellcheck source=bin/shared.sh
source "$(dirname "$0")/shared.sh"

# Show a fancy banner \o/
banner

if [ -z "$*" ]; then
    echo "⚠️ The SQL file path is a required parameter"
else
	while IFS= read -r line; do
		export "$(echo -e "$line" | sed -e 's/[[:space:]]*$//' -e "s/'//g")"
	done < <(cat .env | grep DB_) # Get the "DB_" variables.

    echo "📥 Importing into the '${DB_NAME}' database"
    docker-compose exec database mysql \
        --default-character-set=utf8mb4 \
        -u${DB_USER} \
        -p${DB_PASSWORD} \
        ${DB_NAME} \
        < "$@"

    echo "👌 Done!"
fi
