########################################################################

FROM composer:2.7.9 AS composer

########################################################################

FROM alpine:3.20.3 AS release

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
    php83 \
    php83-fpm \
    php83-ctype \
    php83-curl \
    php83-iconv \
    php83-intl \
    php83-json \
    php83-mbstring \
    php83-openssl \
    php83-phar \
    php83-session \
    php83-tokenizer \
    php83-zip

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN \
  rm /etc/php83/php-fpm.d/* && \
  ln -s /usr/sbin/php-fpm83 /usr/sbin/php-fpm

COPY config/* /etc/php83/

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
