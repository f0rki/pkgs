FROM alpine:3.11.6

RUN set -x && \
    apk add --no-cache nodejs nodejs-npm && \
    npm install -g prettier && \
    npm install -g prettier-plugin-solidity && \
    npm cache clean --force && \
    apk del nodejs-npm

ENTRYPOINT ["prettier"]
CMD ["--help"]
