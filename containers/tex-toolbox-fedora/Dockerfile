FROM registry.fedoraproject.org/fedora-toolbox:latest

RUN dnf upgrade -y \
  && dnf install -y \
    fish tmux \
    wget curl bat jq fzf skim pandoc hexyl \
    neovim \
    clang \
    qpdf \
    meld \
    texlive-scheme-medium

LABEL com.github.containers.toolbox="true" \
      com.github.debarshiray.toolbox="true"

#CMD ["/usr/bin/fish"]
