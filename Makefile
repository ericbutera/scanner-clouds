IMAGE_NAME=scanner-go
MAIN=main.go

include .env
export

IMAGE_NAME=${APP_IMAGE_NAME}
IMAGE_REPO=${APP_IMAGE_REPO}
IMAGE_TAG=${APP_VERSION}

.DEFAULT_GOAL := help

.PHONY: help
help: ## Help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build:
	go build -o bin/app

.PHONY: clean
clean:
	rm bin/*

.PHONY: docker-build
docker-build:
	docker build -t ${IMAGE_REPO}/${IMAGE_NAME}:${IMAGE_TAG} .

.PHONY: docker-run
docker-run:
	docker run --rm \
	-e AWS_PROFILE=test \
	-v ${HOME}/.aws/credentials:/root/.aws/credentials:ro \
	-v ${pwd}/config:/app/config \
	${IMAGE_NAME}

.PHONY: image-build
image-build: ## Build docker image
	docker build -t ${IMAGE_REPO}/${IMAGE_NAME}:${IMAGE_TAG} .

.PHONY: stop
stop: ## Stop the application
	docker compose down


.PHONY: run
run: ## Run the application
	docker compose up