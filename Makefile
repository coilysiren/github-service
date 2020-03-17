
.DEFAULT_GOAL := help

# get docker build image
docker_image := $(shell yq read .circleci/config.yml "executors.default-executor.docker[0].image")

# docker run script
docker_run := docker run -it --rm \
	--workdir=/src \
	--user=root \
	-v $$(pwd):/src \
	-v $$(pwd)/.gocache:/go/pkg \
	-v $$HOME/.aws:/root/.aws \
	-v $$HOME/.ssh:/root/.ssh \
	$(docker_image)

help: # automatically documents the makefile, by outputing everything behind a ##
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.init: # check that dependencies are installed
	@./scripts/check_yq.sh
	@./scripts/check_docker.sh

shell: .init ## 🦞 Start a docker shell
	$(docker_run) bash

lint: .init ## 🧹 Run linters
	$(docker_run) ./scripts/lint.sh

build: .init ## ⚙️  Build into local environment
	$(docker_run) ./scripts/build.sh darwin

test: .init ## ✅ Run tests
	$(docker_run) ./scripts/test.sh
