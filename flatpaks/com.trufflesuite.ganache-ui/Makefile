APP := $(shell basename $(PWD))
PREFIX ?= ~/

.PHONY: clean build install

install:
	flatpak-builder --user --install --force-clean ./build ./$(APP).yaml

build:
	flatpak-builder --force-clean ./build ./$(APP).yaml

run: install
	flatpak run $(APP)

clean:
	-$(RM) -r build

