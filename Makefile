SHELL := /bin/bash

NAME   := danielpops/openvas
TAG    := $$(git log -1 --pretty=%H)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:latest

HOST   := $(shell echo ${NAME} | sed -e 's/\//-/g')

all:
	echo >&2 "Must specify target."

test:
	true

docker_build:
	docker build --rm -t ${IMG} .

docker_run:
	docker run -it --rm -h ${HOST} -p 80 --entrypoint /bin/bash --name ${HOST} ${NAME}

docker_exec:
	docker exec -it ${NAME} /bin/bash

docker_login:
	docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"

docker_push: docker_login docker_build
	docker push ${NAME}

docker_stop:
	docker stop ${HOST} && docker rm -f ${HOST}

.PHONY: all test docker_build docker_run docker_exec docker_stop docker_login docker_push
