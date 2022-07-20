FROM alpine:3.15.5

LABEL \
  org.opencontainers.image.authors="Fabien Schurter <dev@fabschurt.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

RUN \
  apk add --no-cache \
    curl=7.80.0-r2 \
    git=2.34.4-r0 \
    gzip=1.12-r0 \
    tar=1.34-r0 \
    unzip=6.0-r9 \
    nodejs=16.16.0-r0 \
    npm=8.1.3-r0

ONBUILD ARG RUNTIME_USER_ID=1000

ONBUILD RUN \
  adduser -u ${RUNTIME_USER_ID} -D -s /sbin/nologin node && \
  mkdir /opt/app && \
  chown -R node:node /opt/app

ONBUILD WORKDIR /opt/app
ONBUILD USER node
