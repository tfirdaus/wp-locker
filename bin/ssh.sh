#!/bin/bash

# shellcheck source=src/shared.sh
# shellcheck disable=SC1091
source "$(dirname "$0")/shared.sh"

for i in "${@:2}"; do
	case $i in
	    -R=*|--root=*)
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
