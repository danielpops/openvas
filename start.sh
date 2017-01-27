#!/bin/bash
set -e

echo "Starting Redis..."
service redis-server restart

echo "Starting Openvas..."

echo "Starting gsad"
gsad --http-only

echo "Starting openvas-scanner..."
openvassd
echo "Starting openvas-manager"
openvasmd

echo "This may take a minute or two..."
openvasmd --rebuild

echo "Checking setup"

curl -s --insecure --location -o openvas-check-setup.sh https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup
chmod 0755 ./openvas-check-setup.sh
./openvas-check-setup.sh --v8 --server

echo "Done."
