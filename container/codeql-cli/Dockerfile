FROM alpine:latest

ARG CODEQL_VERSION=v2.3.3
ARG CODEQL_URL=https://github.com/github/codeql-cli-binaries/releases/download/$CODEQL_VERSION/codeql-linux64.zip

RUN apk add -u wget

RUN cd /opt \
  && wget -O /tmp/codeql.zip $CODEQL_URL \
  && unzip /tmp/codeql.zip \
  && rm /tmp/codeql.zip

#RUN apk add -u openjdk11-jre

ENTRYPOINT ["/opt/codeql/codeql"]
