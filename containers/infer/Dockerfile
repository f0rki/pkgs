FROM ubuntu:latest

RUN apt-get update \
    && env DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential clang clang-tools wget curl xz-utils tzdata less \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/share/zoneinfo/UTC /etc/localtime || true

ARG VERSION=0.17.0
WORKDIR /opt/
RUN wget -O infer-linux64.tar.xz https://github.com/facebook/infer/releases/download/v$VERSION/infer-linux64-v$VERSION.tar.xz \
  && tar xf infer-linux64.tar.xz \
  && rm infer-linux64.tar.xz \
  && ln -s /opt/infer-linux64-v$VERSION/bin/infer /usr/local/bin/infer

WORKDIR /
ENTRYPOINT ["/usr/local/bin/infer"]
