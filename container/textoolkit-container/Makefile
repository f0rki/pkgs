DOCKER=$(shell command -v podman || command -v docker)
DOCKER_IMAGE_LOCAL=textoolkit
DOCKER_BASEIMAGE=ubuntu:rolling
SUBTAG=
DOCKER_IMAGE_REMOTE=
DOCKER_TAG=$(shell git rev-parse --abbrev-ref HEAD)$(SUBTAG)
BUILD_ARGS=--build-arg WITH_LM=0 --build-arg BASEIMAGE=$(DOCKER_BASEIMAGE)

help: list-vars
	@echo "# build locally with"
	@echo "make build"
	@echo "# push docker image to default registry with"
	@echo "make push"
	@echo "# remove local images with"
	@echo "make clean"

list-vars:
	@echo "# docker configuration"
	@echo DOCKER=$(DOCKER)
	@echo DOCKER_IMAGE_LOCAL=$(DOCKER_IMAGE_LOCAL)
	@echo DOCKER_IMAGE_REMOTE=$(DOCKER_IMAGE_REMOTE)
	@echo DOCKER_TAG=$(DOCKER_TAG)
	@echo ""

git-pull:
	@git pull --ff-only

build: git-pull
	$(DOCKER) build -t $(DOCKER_IMAGE_LOCAL):$(DOCKER_TAG) $(BUILD_ARGS) .
	$(DOCKER) tag $(DOCKER_IMAGE_LOCAL):$(DOCKER_TAG) $(DOCKER_IMAGE_REMOTE):$(DOCKER_TAG)

clean-build: git-pull
	$(DOCKER) build --no-cache -t $(DOCKER_IMAGE_LOCAL):$(DOCKER_TAG) $(BUILD_ARGS) .

login:
	@(test -e .docker-credentials \
		&& echo "logging into docker" \
		&& tail -n 1 .docker-credentials \
		| $(DOCKER) login --password-stdin -u $(shell head -n 1 .docker-credentials) $(DOCKER_IMAGE_REMOTE)) \
		|| true

push: login build
	$(DOCKER) tag $(DOCKER_IMAGE_LOCAL):$(DOCKER_TAG) $(DOCKER_IMAGE_REMOTE):$(DOCKER_TAG)
	$(DOCKER) push $(DOCKER_IMAGE_REMOTE):$(DOCKER_TAG)

pull: login clean
	$(DOCKER) pull $(DOCKER_IMAGE_REMOTE):$(DOCKER_TAG)

container-enter: build
	$(DOCKER) run --rm -it -v $(PWD):$(PWD):Z -w $(PWD) $(DOCKER_IMAGE_LOCAL)

clean: clean-local clean-remote

clean-local:
	$(DOCKER) rmi $(DOCKER_IMAGE_LOCAL):$(DOCKER_TAG) || true

clean-remote:
	$(DOCKER) rmi $(DOCKER_IMAGE_REMOTE):$(DOCKER_TAG) || true

.PHONY: help list-vars build git-pull docker-push pull clean clean-local clean-remote
