########################################################################

FROM alpine:3.20.3 AS release

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
    python3 \
    py3-pip

ONBUILD ARG RUNTIME_USER_ID=1000
ONBUILD ARG RUNTIME_USER_NAME="python"
ONBUILD ARG RUNTIME_DIR="/opt/app"

ONBUILD RUN \
  adduser -u "$RUNTIME_USER_ID" -D -s /sbin/nologin "$RUNTIME_USER_NAME" && \
  mkdir "$RUNTIME_DIR" && \
  chown -R "${RUNTIME_USER_NAME}:${RUNTIME_USER_NAME}" "$RUNTIME_DIR"

ONBUILD WORKDIR "$RUNTIME_DIR"
ONBUILD USER "$RUNTIME_USER_NAME"

########################################################################

FROM release AS test

CMD \
  set -x && \
  [ "$(whoami)" = 'python' ] && \
  [ -d '/opt/app' ] && [ -r '/opt/app' ] && [ -w '/opt/app' ] && \
  [ "$(pwd)" = '/opt/app' ] && \
  python --version && \
  pip --version

########################################################################
