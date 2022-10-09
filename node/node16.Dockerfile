FROM alpine:3.16.2

LABEL \
  org.opencontainers.image.authors="Fabien Schurter <dev@fabschurt.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

RUN \
  apk add --no-cache \
    curl \
    git \
    gzip \
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
