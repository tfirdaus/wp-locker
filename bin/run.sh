#!/bin/bash

# shellcheck source=src/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

# drun: docker-compose run
drun "$@"
