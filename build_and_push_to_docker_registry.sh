#!/bin/bash
set -ev

TAG="danielpops/openvas:$TRAVIS_COMMIT"

docker build -t ${TAG} . > /dev/null
docker push ${TAG}
