########################################################################

FROM composer:2.4.1 AS composer

########################################################################

FROM alpine:3.15.6

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
    php7 \
    php7-fpm \
    php7-curl \
    php7-iconv \
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
