#!/bin/bash
set -ev

TAG="danielpops/openvas:$TRAVIS_COMMIT"

make docker_build
make docker_push
