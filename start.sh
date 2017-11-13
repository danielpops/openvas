#!/bin/bash
set -e

echo "Starting Redis..."
service redis-server restart

echo "Starting Openvas..."

echo "Loading all NVTs..."
openvassd --foreground --only-cache

echo "Starting openvas-scanner..."
openvassd

echo "Rebuilding the NVT/CVE databases..."
openvasmd --rebuild --progress

echo "Starting openvamsd listening on 127.0.0.1..."
openvasmd --listen=127.0.0.1

echo "Starting gsad in http-only mode, connecting to openvasmd on 127.0.0.1..."
gsad --http-only --mlisten 127.0.0.1

echo "Checking setup"

curl -s --insecure --location -o openvas-check-setup.sh https://svn.wald.intevation.org/svn/openvas/trunk/tools/openvas-check-setup
chmod 0755 ./openvas-check-setup.sh
./openvas-check-setup.sh --v9 --server

echo "Done."
