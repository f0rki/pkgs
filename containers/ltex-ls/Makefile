DOCKER=$(shell command -v podman || command -v docker)
DOCKER_IMAGE=ltex-ls
BUILD_ARGS=

help:
	@echo "build locally with"
	@echo -e "\tmake build"

list-vars:
	@echo "# make config"
	@echo DOCKER=$(DOCKER)
	@echo DOCKER_IMAGE=$(DOCKER_IMAGE)
	@echo ""

build:
	$(DOCKER) build -t $(DOCKER_IMAGE) $(BUILD_ARGS) .

.PHONY: help list-vars build
