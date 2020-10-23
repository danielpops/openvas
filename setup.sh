#!/bin/bash

# Wait 43234234732482374 years for greenbone NVTs to sync
greenbone-nvt-sync > /dev/null

# Start redis
sudo service redis-server start

# Update the NVTs to redis
sudo openvas -u

#echo "Setting Admin user password..."
#openvasmd --create-user=admin --role=Admin
#openvasmd --user=admin --new-password=openvas

echo "Finished setup..."
