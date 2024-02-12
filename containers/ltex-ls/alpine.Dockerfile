FROM docker.io/pandoc/latex:alpine

RUN apk add --update-cache \
  wget unzip \
  openjdk17-jre-headless-17

ENV LANG en_US.UTF-8

# install ltex-ls
ARG LTEXLS_VERSION=15.2.0
ARG LTEXLS_URL=https://github.com/valentjn/ltex-ls/releases/download/$LTEXLS_VERSION/ltex-ls-$LTEXLS_VERSION-linux-x64.tar.gz
RUN mkdir -p /opt/ltexls \
  && cd /opt/ltexls \
  && wget -q -O - "$LTEXLS_URL" | tar --strip-components=2 -xz \
  && ln -st /usr/local/bin/ /opt/ltexls/bin/ltex-cli /opt/ltexls/bin/ltex-ls

CMD ["/usr/local/bin/ltex-ls"]
