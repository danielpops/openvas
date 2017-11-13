SHELL := /bin/bash

TAG?=danielpops/openvas
NAME:= $(shell echo ${TAG} | sed -e 's/\//-/g')

all:
	echo >&2 "Must specify target."

whoami    := $(shell who | awk '{print $$1}')

test:
	true

docker_build:
	docker build --rm -t $(TAG) .

docker_run:
	docker run -it --rm -h docker-$(NAME) -p 80 --entrypoint /bin/bash --name $(NAME) $(TAG)

docker_exec:
	docker exec -it $(NAME) /bin/bash

docker_login:
	docker login -u "$(DOCKER_USERNAME)" -p "$(DOCKER_PASSWORD)"

docker_push: docker_login docker_build
	docker push $(TAG)

docker_stop:
	docker stop $(NAME) && docker rm -f $(NAME)

.PHONY: all test docker_build docker_run docker_exec docker_stop docker_login docker_push
