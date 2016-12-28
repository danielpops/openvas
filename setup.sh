#!/bin/bash

openvas-nvt-sync

/etc/init.d/openvas-manager stop
/etc/init.d/openvas-scanner stop

openvas-mkcert-client -n -i

openvassd
openvasmd --rebuild --progress

openvas-scapdata-sync
openvas-certdata-sync


echo "Setting Admin user password..."
openvasmd --create-user=admin --role=Admin
openvasmd --user=admin --new-password=openvas

echo "Finished setup..."
