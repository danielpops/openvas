#!/bin/bash

openvas-manage-certs -a -i -f

greenbone-nvt-sync > /dev/null
greenbone-scapdata-sync
greenbone-certdata-sync


echo "Setting Admin user password..."
openvasmd --create-user=admin --role=Admin
openvasmd --user=admin --new-password=openvas

echo "Finished setup..."
