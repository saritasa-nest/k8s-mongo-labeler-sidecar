.PHONY: all
.DEFAULT_GOAL := help

# ----------------------------------------------------------------------------
# Local Variables
#
# ============================================================================
DOCKER_REGISTRY=saritasallc/k8s-mongo-labeler-sidecar

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "⚡ \033[34m%-30s\033[0m %s\n", $$1, $$2}'

all: build ## Build and push

# ----------------------------------------------------------------------------
# Docker Helper Commands
# make build
#
# ============================================================================

docker_login: ## Login to Dockerhub
	docker login -u saritasallc -p `pass saritasallc/docker/password` docker.io

build: build-1.20-bullseye

build-1.20-bullseye:
	make VERSION=0.1 IMAGE_TAG=1.20-bullseye build-push-image

build-push-image: docker_login ## Build and push to public registry
	docker build -t ${DOCKER_REGISTRY}:latest --build-arg IMAGE_TAG=${IMAGE_TAG} .
	docker tag ${DOCKER_REGISTRY}:latest ${DOCKER_REGISTRY}:${IMAGE_TAG}-${VERSION}
	docker push ${DOCKER_REGISTRY}:${IMAGE_TAG}-${VERSION}
	docker push ${DOCKER_REGISTRY}:latest
