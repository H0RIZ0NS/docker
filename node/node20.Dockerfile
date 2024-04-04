########################################################################

FROM alpine:3.19.1 as release

LABEL \
  org.opencontainers.image.authors="Fabien Schurter" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

RUN \
  apk add --no-cache \
    ca-certificates \
    curl \
    git \
    gzip \
    openssl \
    tar \
    unzip \
    nodejs \
    npm

ONBUILD ARG RUNTIME_USER_ID=1000

ONBUILD RUN \
  adduser -u ${RUNTIME_USER_ID} -D -s /sbin/nologin node && \
  mkdir /opt/app && \
  chown -R node:node /opt/app

ONBUILD WORKDIR /opt/app
ONBUILD USER node

########################################################################

FROM release as test

CMD \
  set -x && \
  [ "$(whoami)" = 'node' ] && \
  [ -d '/opt/app' ] && [ -r '/opt/app' ] && [ -w '/opt/app' ] && \
  [ "$(pwd)" = '/opt/app' ] && \
  node --version && \
  npm --version

########################################################################
