#!/bin/bash

# shellcheck source=bin/shared.sh
source "$(dirname "$0")/shared.sh"

# Show a fancy banner \o/
banner

for i in "$@"; do
	case $i in
	    --root)
	    IS_ROOT=1
	    shift
	    ;;
	    *)
	    ;;
	esac
done

if [[ $IS_ROOT = "1" ]]; then
	echo "🤓 Logging in to SSH with 'root'."
	ssh_root
else
	echo "🙂 Logging in to SSH with 'www-data' user."
	ssh
fi
