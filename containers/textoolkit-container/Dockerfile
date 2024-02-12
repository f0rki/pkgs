ARG BASEIMAGE=docker.io/ubuntu:rolling
ARG RUSTBUILDER=docker.io/rust:latest
ARG GOBUILDER=docker.io/golang:latest

###############################################################################
# Build tectonic from source - we are using the base image instead of the 
# standard rust image, because we need to install some C library dependencies.
FROM $BASEIMAGE as tectonic-builder

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
  && apt-get install -q -y \
    build-essential \
    cargo \
    libfontconfig1-dev libgraphite2-dev libharfbuzz-dev libicu-dev libssl-dev zlib1g-dev \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /build \
  && cd /build \
  && cargo install tectonic \
  && cp /root/.cargo/bin/tectonic .

###############################################################################
FROM $RUSTBUILDER as delta-builder
RUN mkdir -p /build \
  && cargo install git-delta \
  && cp /usr/local/cargo/bin/* /build/

###############################################################################
FROM $RUSTBUILDER as texlab-builder
RUN cargo install --git https://github.com/latex-lsp/texlab.git --locked \
  && mkdir -p /build \
  && cp /usr/local/cargo/bin/* /build/

###############################################################################
# Build bibclean from source
FROM $BASEIMAGE as bibclean-builder

ARG BIBCLEAN_VERSION=3.06

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
  && apt-get install -q -y \
    build-essential wget \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /build \
  && ( mkdir -p /usr/local/man/man1/ || true ) \
  && cd /build \
  && wget -q -O - "http://ftp.math.utah.edu/pub/bibclean/bibclean-$BIBCLEAN_VERSION.tar.xz" | tar xJ \
  && cd bibclean* \
  && ./configure --prefix=/usr/local/ \
  && make install

###############################################################################
# build textidote from source
FROM $BASEIMAGE as textidote-builder
ARG TEXTIDOTE_REF=master
ARG TEXTIDOTE_REL_URL=https://github.com/sylvainhalle/textidote/releases/download/v0.8.3/textidote.jar

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -q \
  && apt-get install -q -y \
    git wget unzip \
    default-jdk-headless \
    ant \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

#RUN && mkdir -p /build \
#  && cd /build \
#  && git clone --depth=1 -b $TEXTIDOTE_REF \
#    https://github.com/sylvainhalle/textidote.git \
#  && cd textidote \
#  && ant download-deps \
#  && ant

#RUN cd /build/textidote && ant test 

# download github release
RUN mkdir -p /build/textidote \
  && wget -q -O /build/textidote/textidote.jar $TEXTIDOTE_REL_URL

###############################################################################
# build vale from source
FROM $GOBUILDER as vale-builder

ARG VALE_REPO=https://github.com/errata-ai/vale.git
ARG VALE_BRANCH=v2

RUN mkdir -p /build \
  && cd /build \
  && git clone --depth=1 -b "$VALE_BRANCH" "$VALE_REPO" \
  && cd vale \
  && ( mkdir -p bin || true ) \
  && make build os=linux exe=vale \
  && ( mkdir -p /usr/local/bin/ || true ) \
  && cp bin/vale /usr/local/bin/


###############################################################################
# final image stage
FROM $BASEIMAGE

# some build config
ARG WITH_LM=1
ARG LM_URL=https://languagetool.org/download/ngram-data
ARG LT_VERSION=stable
ARG LT_URL=https://languagetool.org/download/LanguageTool-$LT_VERSION.zip

ARG DEBIAN_FRONTEND=noninteractive

# Install full texlive from repositories
RUN set -x; apt-get update -q \
  && apt-get install -q -y \
    bash \
    wget curl git unzip make \
    openssh-client \
    pandoc pandoc-citeproc \
    python3-pygments fig2dev \
    python3-pip python3-dev build-essential python-is-python3 \
    default-jre-headless \
    texlive-full \
    latexmk \
    libfontconfig1 libgraphite2-3 libharfbuzz-bin zlib1g \
    libicu70 libssl3 \
    pdftk \
    chktex \
    lacheck \
    locales \
    mupdf-tools \
  && apt-get --purge remove -y .\*-doc$ \
  && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# copy previously built artifacts to final image
COPY --from=textidote-builder /build/textidote/textidote.jar /opt/textidote.jar
COPY --from=tectonic-builder  /build/tectonic                /usr/local/bin/tectonic
COPY --from=delta-builder     /build/delta                   /usr/local/bin/delta
COPY --from=texlab-builder    /build/texlab                  /usr/local/bin/texlab
COPY --from=bibclean-builder  /usr/local/bin/bibclean        /usr/local/bin/bibclean
COPY --from=bibclean-builder  /usr/local/share/bibclean      /usr/local/share/bibclean
COPY --from=vale-builder      /usr/local/bin/vale            /usr/local/bin/vale

# install pre-built artifacts and scripts

# install languagetool 
RUN wget -q -O /opt/lt.zip "$LT_URL" \
  && cd /opt \
  && unzip lt.zip \
  && mv LanguageTool* languagetool \
  && cd /opt/languagetool \
  && mkdir bin \
  && cd bin \
  && ln -s ../languagetool*.jar . \
  && chmod +x *.jar \
  && rm /opt/lt.zip

# install redpen
ARG REDPEN_VERSION=1.10.4
RUN mkdir -p /opt/redpen/ \
  && cd /opt/redpen \
  && wget -q -O - https://github.com/redpen-cc/redpen/releases/download/redpen-$REDPEN_VERSION/redpen-$REDPEN_VERSION.tar.gz | tar xz \
  && ln -s $PWD/$(ls redpen-distribution-*/bin/redpen) /usr/local/bin/redpen \
  && ln -s $PWD/$(ls redpen-distribution-*/bin/redpen-server) /usr/local/bin/redpen-server

# install ltex-ls
ARG LTEXLS_VERSION=15.2.0
ARG LTEXLS_URL=https://github.com/valentjn/ltex-ls/releases/download/$LTEXLS_VERSION/ltex-ls-$LTEXLS_VERSION-linux-x64.tar.gz
RUN mkdir -p /opt/ltexls \
  && cd /opt/ltexls \
  && wget -q -O - "$LTEXLS_URL" | tar --strip-components=2 -xz \
  && test -e /opt/ltexls/bin/ltex-cli

ENV PATH=$PATH:/opt/ltexls/bin

# install git-latexdiff
RUN cd /tmp \
  && git clone --depth=1 https://gitlab.com/git-latexdiff/git-latexdiff.git \
  && cd /tmp/git-latexdiff \
  && make install-bin \
  ; rm -rf /tmp/git-latexdiff

# install arxiv cleaner(s)
# this is the one by google
RUN pip3 install arxiv-latex-cleaner
# and this is the older one, which is imho more nice
RUN pip3 install arxiv-collector

# install custom scripts
COPY fetch-lt-ngrams-model.sh /usr/local/bin/ 
COPY textidote-ci /usr/local/bin/
COPY bibclean-ci /usr/local/bin/
RUN chmod +x /usr/local/bin/*

ENV PATH=$PATH:/usr/local/bin/:/opt/languagetool/bin/

RUN dpkg-reconfigure dash

# The very last step is to download the full languagetool ngrams model
RUN test "$WITH_LM" -ne 1 \
  || bash /usr/local/bin/fetch-lt-ngrams-model.sh
