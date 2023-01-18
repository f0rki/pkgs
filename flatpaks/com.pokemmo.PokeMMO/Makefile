APP_ID=com.pokemmo.PokeMMO
FLATHUB_REPO=https://flathub.org/repo/flathub.flatpakrepo

RUNTIME_PLATFORM := org.freedesktop.Platform
RUNTIME_SDK      := org.freedesktop.Sdk
RUNTIME_SDK_JAVA := org.freedesktop.Sdk.Extension.openjdk17
RUNTIME_VERSION  := 22.08

BUILD_DIR := build
REPO_DIR  := repo
OPTS := --user

all: $(APP_ID).flatpak

$(APP_ID).flatpak: $(BUILD_DIR) $(REPO_DIR)
	flatpak build-bundle $(REPO_DIR) $@ $(APP_ID)

$(BUILD_DIR) $(REPO_DIR): $(APP_ID).yaml
	flatpak-builder --force-clean --repo=$(REPO_DIR) $(BUILD_DIR) $^
	flatpak build-update-repo $(REPO_DIR)

.PHONY: install
install: $(APP_ID).flatpak
	flatpak $(OPTS) install $^

.PHONY: uninstall
uninstall:
	flatpak $(OPTS) remove $(APP_ID)

.PHONY: clean
clean:
	$(RM) -fr $(BUILD_DIR) $(REPO_DIR) $(APP_ID).flatpak

.PHONY: run
run:
	flatpak $(OPTS) run $(APP_ID)

.PHONY: debug
debug:
	flatpak $(OPTS) run --devel --command=bash $(APP_ID)

.PHONY: setup
setup:
	flatpak $(OPTS) remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	flatpak $(OPTS) install flathub $(RUNTIME_PLATFORM)//$(RUNTIME_VERSION)
	flatpak $(OPTS) install flathub $(RUNTIME_SDK)//$(RUNTIME_VERSION)
	flatpak $(OPTS) install flathub $(RUNTIME_SDK_JAVA)//$(RUNTIME_VERSION)

