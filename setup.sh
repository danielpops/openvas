#!/bin/bash

openvas-mkcert -q > /dev/null
openvas-mkcert-client -n -i > /dev/null

openvas-nvt-sync > /dev/null
openvas-scapdata-sync
openvas-certdata-sync


echo "Setting Admin user password..."
openvasmd --create-user=admin --role=Admin
openvasmd --user=admin --new-password=openvas

echo "Finished setup..."
