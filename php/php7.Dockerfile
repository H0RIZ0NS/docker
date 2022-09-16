########################################################################

FROM composer:2.4.1 AS composer

########################################################################

FROM alpine:3.15.5

LABEL \
  org.opencontainers.image.authors="Fabien Schurter <dev@fabschurt.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

ENV PHP_VERSION="7.4.30-r0"

RUN \
  apk add --no-cache \
    curl=7.80.0-r3 \
    git=2.34.4-r0 \
    gzip=1.12-r0 \
    tar=1.34-r0 \
    unzip=6.0-r9 \
    php7=${PHP_VERSION} \
    php7-fpm=${PHP_VERSION} \
    php7-curl=${PHP_VERSION} \
    php7-iconv=${PHP_VERSION} \
    php7-json=${PHP_VERSION} \
    php7-mbstring=${PHP_VERSION} \
    php7-openssl=${PHP_VERSION} \
    php7-phar=${PHP_VERSION} \
    php7-session=${PHP_VERSION} \
    php7-tokenizer=${PHP_VERSION} \
    php7-zip=${PHP_VERSION}

COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN \
  rm /etc/php7/php-fpm.d/* && \
  ln -s /usr/sbin/php-fpm7 /usr/sbin/php-fpm

COPY config/* /etc/php7/

ONBUILD ARG RUNTIME_USER_ID=1000

ONBUILD RUN \
  adduser -u ${RUNTIME_USER_ID} -D -s /sbin/nologin php && \
  mkdir \
    /opt/app \
    /var/lib/php7/sessions \
  && \
  chown -R php:php \
    /opt/app \
    /var/lib/php7/sessions

ONBUILD WORKDIR /opt/app
ONBUILD USER php

########################################################################
