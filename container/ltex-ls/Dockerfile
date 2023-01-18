FROM ubuntu:rolling

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -qq -y \
    wget unzip \
    pandoc pandoc-citeproc \
    default-jre-headless \
    locales \
  && apt-get --purge remove -y .\*-doc$ \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# install ltex-ls
ARG LTEXLS_VERSION=15.2.0
ARG LTEXLS_URL=https://github.com/valentjn/ltex-ls/releases/download/$LTEXLS_VERSION/ltex-ls-$LTEXLS_VERSION-linux-x64.tar.gz
RUN mkdir -p /opt/ltexls \
  && cd /opt/ltexls \
  && wget -q -O - "$LTEXLS_URL" | tar --strip-components=2 -xz \
  && ln -st /usr/local/bin/ /opt/ltexls/bin/ltex-cli /opt/ltexls/bin/ltex-ls

CMD ["/usr/local/bin/ltex-ls"]
