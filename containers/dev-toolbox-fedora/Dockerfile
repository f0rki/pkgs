FROM registry.fedoraproject.org/fedora-toolbox:latest

RUN dnf upgrade -y \
  && dnf install -y \
    fish tmux \
    wget curl bat jq fzf skim pandoc \
    git make \
    hexyl git-delta difftastic \
    rizin cutter-re \
    neovim python3-neovim \
    binutils gcc llvm clang clang-tools-extra \
    gdb lldb \
    cppcheck flawfinder \
    uncrustify \
    python3 python3-pip pipenv python3-devel \
    python3-mypy python3-mypy_extensions bandit python3-yapf \
    golang \
    qpdf \
    ghostscript \
    ImageMagick ImageMagick-libs

    # meld \
    # texlive-scheme-medium \
    # texlive-pdfx texlive-diagbox texlive-blindtext texlive-cleveref \
    # texlive-minted texlive-todonotes

# TODO: doesn't work properly, because of the different users.
# ENV RUSTUP_HOME=/opt/rustup
# RUN mkdir -p $RUSTUP_HOME \
#   && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
#       | sh -s -- -y;
# ENV PATH=$PATH:$HOME/.cargo/bin
# RUN export PATH=$PATH:$HOME/.cargo/bin/ \
#   && rustup component add rust-src rls clippy rustfmt \
#   && rustup toolchain install nightly 

LABEL com.github.containers.toolbox="true" \
      com.github.debarshiray.toolbox="true"

#CMD ["/usr/bin/fish"]
