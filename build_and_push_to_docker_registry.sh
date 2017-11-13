#!/bin/bash
set -ev

TAG="danielpops/openvas:$TRAVIS_COMMIT"

echo "Tag is ${TAG}"

docker build -t ${TAG} .
docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"
docker push ${TAG}
