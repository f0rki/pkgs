FROM registry.fedoraproject.org/fedora:latest

RUN dnf install -y \
      flatpak flatpak-builder \
      python3-requests \
      python3-gobject \
      make \
    && dnf clean all

RUN set -ex; \
    flatpak remote-add --user flathub https://flathub.org/repo/flathub.flatpakrepo; \
    flatpak remote-add --user flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo; \
    flatpak remote-add --user fedora oci+https://registry.fedoraproject.org
