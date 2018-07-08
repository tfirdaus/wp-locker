#!/usr/bin/env bash

# Enable and activate SSL.
a2enmod ssl
a2ensite wp-locker
a2ensite wp-locker-ssl

docker-entrypoint.sh apache2-foreground
