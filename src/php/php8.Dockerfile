########################################################################

FROM composer:2.10.3 AS composer

########################################################################

FROM alpine:3.24.2 AS release

LABEL \
  org.opencontainers.image.authors="Fabien Schurter" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

STOPSIGNAL SIGQUIT

RUN \
  apk add --no-cache \
    ca-certificates \
    curl \
    git \
    gzip \
    openssl \
    tar \
    unzip \
    php85 \
    php85-fpm \
    php85-ctype \
    php85-curl \
    php85-iconv \
    php85-intl \
    php85-json \
    php85-mbstring \
    php85-openssl \
    php85-phar \
    php85-session \
    php85-tokenizer \
    php85-zip

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN \
  rm /etc/php85/php-fpm.d/* && \
  ln -s /usr/sbin/php-fpm85 /usr/sbin/php-fpm

COPY config/* /etc/php85/

ONBUILD ARG RUNTIME_USER_ID=1000
ONBUILD ARG RUNTIME_USER_NAME="php"
ONBUILD ARG RUNTIME_DIR="/opt/app"
ONBUILD ARG PHP_SESSION_DIR="/var/lib/php/sessions"

ONBUILD RUN \
  adduser -u "$RUNTIME_USER_ID" -D -s /sbin/nologin "$RUNTIME_USER_NAME" && \
  mkdir -p \
    "$RUNTIME_DIR" \
    "$PHP_SESSION_DIR" \
  && \
  chown -R "${RUNTIME_USER_NAME}:${RUNTIME_USER_NAME}" \
    "$RUNTIME_DIR" \
    "$PHP_SESSION_DIR"

ONBUILD WORKDIR "$RUNTIME_DIR"
ONBUILD USER "$RUNTIME_USER_NAME"

########################################################################

FROM release AS test

CMD \
  set -x && \
  [ "$(whoami)" = 'php' ] && \
  [ -d '/var/lib/php/sessions' ] && [ -r '/var/lib/php/sessions' ] && [ -w '/var/lib/php/sessions' ] && \
  [ -d '/opt/app' ] && [ -r '/opt/app' ] && [ -w '/opt/app' ] && \
  [ "$(pwd)" = '/opt/app' ] && \
  php --version && \
  php-fpm --version && \
  composer --version

########################################################################
