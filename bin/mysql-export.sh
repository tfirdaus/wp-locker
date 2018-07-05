#!/bin/bash

# shellcheck source=bin/shared.sh
source "$(dirname "$0")/shared.sh"

# Show a fancy banner \o/
banner

TIMESTAMP=$(date +"%Y-%m-%d-%H%M%S")

while IFS= read -r line; do
	export "$(echo -e "$line" | sed -e 's/[[:space:]]*$//' -e "s/'//g")"
done < <(cat .env | grep DATABASE_) # Get the "DATABASE_" variables.

echo "📤 Exporting the '${DATABASE_NAME}' database."
echo "📦 Generating dump/${DATABASE_NAME}-${TIMESTAMP}.sql."

# Make sure the '/data' directory exist to store the database dump
mkdir -p data
docker-compose exec database mysqldump --opt \
    -h ${DATABASE_HOST%:*} \
    -P${DATABASE_HOST#*:} \
    -u ${DATABASE_USER} \
    -p${DATABASE_PASSWORD} \
    ${DATABASE_NAME} \
    > dump/${DATABASE_NAME}-${TIMESTAMP}.sql
echo "👌 Done!"
