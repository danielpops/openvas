#!/bin/bash

# Wait 43234234732482374 years for greenbone NVTs to sync
greenbone-nvt-sync > /dev/null

# Same for scapdata and certdata, but they are "optional"
#greenbone-scapdata-sync > /dev/null
#greenbone-certdata-sync > /dev/null

# Start redis
sudo service redis-server start

# Update the NVTs to redis
sudo openvas -u

# Set up postgres
sudo service postgresql start
sudo -u postgres createuser -DRS nobody
sudo -u postgres createdb -O nobody gvmd
sudo -u postgres psql gvmd -c 'create role dba with superuser noinherit;'
sudo -u postgres psql gvmd -c 'grant dba to nobody;'

sudo -u postgres psql gvmd -c 'create extension "uuid-ossp";'
sudo -u postgres psql gvmd -c 'create extension "pgcrypto";'

#echo "Setting Admin user password..."
#openvasmd --create-user=admin --role=Admin
#openvasmd --user=admin --new-password=openvas

echo "Finished setup..."
