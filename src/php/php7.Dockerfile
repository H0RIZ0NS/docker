########################################################################

FROM composer:2.7.9 AS composer

########################################################################

FROM alpine:3.15.11 AS release

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
    php7 \
    php7-fpm \
    php7-ctype \
    php7-curl \
    php7-iconv \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-openssl \
    php7-phar \
    php7-session \
    php7-tokenizer \
    php7-zip

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN \
  rm /etc/php7/php-fpm.d/* && \
  ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm

COPY config/* /etc/php7/

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
