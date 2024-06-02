########################################################################

FROM composer:2.7.6 AS composer

########################################################################

FROM alpine:3.20.0 as release

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

ONBUILD RUN \
  adduser -u ${RUNTIME_USER_ID} -D -s /sbin/nologin php && \
  mkdir -p \
    /opt/app \
    /var/lib/php/sessions \
  && \
  chown -R php:php \
    /opt/app \
    /var/lib/php/sessions

ONBUILD WORKDIR /opt/app
ONBUILD USER php

########################################################################

FROM release as test

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
