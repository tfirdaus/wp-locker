#!/bin/bash

echo "⛔️ This operation will remove the localhost containers, volumes, and the WordPress core files."
while true; do
    read -rp "Do you wish to proceed? [y/n]" yn
    case $yn in
        [Yy]* ) "$(dirname "$0")"/down.sh --volumes && rm -rf wordpress; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
