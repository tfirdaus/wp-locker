#!/bin/bash

# shellcheck source=bin/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

while IFS= read -r line; do
	export "$(echo -e "$line" | sed -e 's/[[:space:]]*$//' -e "s/'//g")"
done < <(grep DB_ .env)

if [ -z "$*" ]; then
    echo "⚠️ The SQL file path is a required parameter"
else
    echo "📥 Importing into the '${DB_NAME}' database"

	# shellcheck disable=SC2086
    docker-compose exec database mysql \
        --default-character-set=utf8mb4 \
        -u${DB_USER} \
        -p${DB_PASSWORD} \
        ${DB_NAME} \
        < "$@"

    echo "👌 Done!"
fi
