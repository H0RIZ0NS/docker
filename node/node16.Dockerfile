FROM alpine:3.15.4

LABEL \
  org.opencontainers.image.authors="Fabien Schurter <dev@fabschurt.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

RUN \
  apk add --no-cache \
    nodejs=16.14.2-r0 \
    npm=8.1.3-r0 \
    curl=7.80.0-r2 \
    git=2.34.2-r0 \
    gzip=1.12-r0 \
    tar=1.34-r0 \
    unzip=6.0-r9

ONBUILD ARG RUNTIME_USER_ID=1000

ONBUILD RUN \
  adduser -u ${RUNTIME_USER_ID} -D -s /sbin/nologin node && \
  mkdir /opt/app && \
  chown -R node:node /opt/app

ONBUILD WORKDIR /opt/app
ONBUILD USER node
