#!/bin/bash

openvas-mkcert -q
openvas-mkcert-client -n -i

openvas-nvt-sync
openvas-scapdata-sync
openvas-certdata-sync


echo "Setting Admin user password..."
openvasmd --create-user=admin --role=Admin
openvasmd --user=admin --new-password=openvas

echo "Finished setup..."