
.DEFAULT_GOAL := help

# get docker build image
docker_image := $(shell yq read .circleci/config.yml "executors.default-executor.docker[0].image")

# docker run script
docker_run := docker run -it --rm \
	--workdir=/src \
	--user=root \
	--publish 8080:8080 \
	--env GIN_MODE=release \
	--env TF_VAR_AWS_ACCOUNT_ID="$(AWS_ACCOUNT_ID)" \
	--env TF_VAR_AWS_REGION="$(AWS_REGION)" \
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

run: .init ## 🏃🏽‍♀️ Run local web server in prod mode, inside docker
	$(docker_run) ./scripts/run.sh

dev: .init ## 🏃🏽‍♀️⚙️ Run local web server in dev mode
	./scripts/run.sh

test: .init ## ✅ Run tests
	$(docker_run) ./scripts/test.sh

plan: .init ## 🗺  Run a deploy plan
	$(docker_run) ./scripts/plan.sh

apply: .init ## 📈 Deploy changes
	$(docker_run) ./scripts/deploy.sh

deploy: plan apply # alias
