# Makefile
# https://qiita.com/mt08/  

DAEMON=0

DOCKER_IMAGE_NAME=mt08/rpi-radiko
DOCKER_IMAGE_VERSION=2017.1211.1
DOCKER_CONTAINER_NAME=radio


ifeq ($(DAEMON),1)
	DOCKER_OPT=-d
else
	DOCKER_OPT=-it
endif

all:


run:
	make stop
	docker run ${DOCKER_OPT} --rm --net=host --privileged --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_NAME}
play:
	docker exec -it ${DOCKER_CONTAINER_NAME} /bin/bash

stop:
	docker ps -a | grep "${DOCKER_IMAGE_NAME}" | cut -f 1 -d' ' | xargs -P1 -i docker stop -t 0 {}

status:
	docker ps -a 

build: Dockerfile rpi-ap_start.sh
	docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} .
	docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ${DOCKER_IMAGE_NAME}:latest

clean:
	# Stop container(s)
	docker ps -a | grep "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}" | cut -f 1 -d' ' | xargs -P1 -i docker stop -t 0 {}
	# Remove container(s)
	docker ps -a | grep "${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}" | cut -f 1 -d' ' | xargs -P1 -i docker rm {}
	# Remove Image(s)
	docker images "${DOCKER_IMAGE_NAME}" | sed 's/\s\+/ /g' | tail -n +2 | cut -f 2 -d ' '| xargs -P1 -i docker rmi ${DOCKER_IMAGE_NAME}:{}


.PHONY: all run stop status build clean
