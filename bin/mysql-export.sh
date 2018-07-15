#!/bin/bash

# shellcheck source=bin/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S")

while IFS= read -r line; do
	export "$(echo -e "$line" | sed -e 's/[[:space:]]*$//' -e "s/'//g")"
done < <(grep DB_ .env)

echo "📤 Exporting the '${DB_NAME}' database."
echo "📦 Generating dump/${DB_NAME}-${TIMESTAMP}.sql."

# Make sure the '/data' directory exist to store the database dump
mkdir -p dump

# shellcheck disable=SC2086
docker-compose exec database mysqldump --opt \
    -h ${DB_HOST%:*} \
    -P${DB_HOST#*:} \
    -u ${DB_USER} \
    -p${DB_PASSWORD} \
    ${DB_NAME} \
    > dump/${DB_NAME}-${TIMESTAMP}.sql

echo "👌 Done!"
