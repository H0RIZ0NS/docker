FROM alpine:3.16.2

LABEL \
  org.opencontainers.image.authors="Fabien Schurter <dev@fabschurt.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

RUN \
  apk add --no-cache \
    curl=7.83.1-r3 \
    git=2.36.2-r0 \
    gzip=1.12-r0 \
    tar=1.34-r0 \
    unzip=6.0-r9 \
    nodejs=16.16.0-r0 \
    npm=8.10.0-r0

ONBUILD ARG RUNTIME_USER_ID=1000

ONBUILD RUN \
  adduser -u ${RUNTIME_USER_ID} -D -s /sbin/nologin node && \
  mkdir /opt/app && \
  chown -R node:node /opt/app

ONBUILD WORKDIR /opt/app
ONBUILD USER node
