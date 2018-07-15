#!/bin/bash

# shellcheck source=bin/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

echo -e "\\n⛔️ This operation will remove the localhost containers, volumes, and the WordPress core files."

while true; do
    read -rp "Do you wish to proceed? [y/n]" yn
    case $yn in
        [Yy]* ) "$(dirname "$0")"/down.sh --volumes && rm -rf wordpress; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
