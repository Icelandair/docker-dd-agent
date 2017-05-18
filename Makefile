ifndef COMPONENT
	COMPONENT := dd-agent
endif

ifndef PROJECT_NAME
	PROJECT_NAME := icelandairlabs-com
endif

ifndef DOMAIN
	DOMAIN := icelandairlabs.com
endif

ifndef DOCKER_REGISTRY_HOST
	DOCKER_REGISTRY_HOST := docker.${DOMAIN}
endif

ifndef PIPELINE_VERSION
	PIPELINE_VERSION := latest
endif

ifndef IMAGE_TAG
	IMAGE_TAG := $(shell git rev-parse --short HEAD)
endif

ifndef DOCKER_IMAGE
	DOCKER_IMAGE := ${DOCKER_REGISTRY_HOST}/${PROJECT_NAME}/${COMPONENT}:${IMAGE_TAG}
endif

all: docker-build docker-push deployment

# docker
docker-build:
	docker build -t ${DOCKER_IMAGE} .

docker-push:
	docker push ${DOCKER_IMAGE}

# deployment

deployment:
	@cat ${COMPONENT}.deployment.yml | \
	TPL_DOCKER_IMAGE=${DOCKER_IMAGE} \
	util/env_replace.py TPL_DOCKER_IMAGE | \
	kubectl apply -f -

# service

service:
	kubectl apply -f ${COMPONENT}.service.yml

apply-config:
	YAML_TEMPLATE_FILE=${COMPONENT}.config.yml ./apply-config.sh

clean-config:
	@kubectl delete -f ${COMPONENT}.config.yml --ignore-not-found
