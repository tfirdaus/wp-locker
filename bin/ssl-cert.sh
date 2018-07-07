#!/bin/bash
echo "🔐 Generating SSL cert."

sudo openssl genrsa -out ssl/certs/wp-locker-key.pem 2048
sudo openssl req -new -out ssl/certs/wp-locker-csr.pem -key ssl/certs/wp-locker-key.pem -config ssl/certs.conf
sudo openssl x509 -req -days 3650 -in ssl/certs/wp-locker-csr.pem -signkey ssl/certs/wp-locker-key.pem -out ssl/certs/wp-locker-crt.pem -extensions v3_req -extfile ssl/certs.conf

# Examine the SSL cert.
openssl x509 -in ssl/certs/wp-locker-crt.pem -text -noout
echo "👌 Done!"
