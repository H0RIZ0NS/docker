########################################################################

FROM composer:2.2.6 AS composer

########################################################################

FROM alpine:3.15.4

LABEL \
  org.opencontainers.image.authors="Fabien Schurter <dev@fabschurt.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

RUN \
  apk add --no-cache \
    php7=7.4.28-r0 \
    php7-fpm=7.4.28-r0 \
    php7-curl=7.4.28-r0 \
    php7-iconv=7.4.28-r0 \
    php7-mbstring=7.4.28-r0 \
    php7-phar=7.4.28-r0 \
    php7-zip=7.4.28-r0 \
    curl=7.80.0-r0 \
    git=2.34.2-r0 \
    gzip=1.12-r0 \
    tar=1.34-r0 \
    unzip=6.0-r9

RUN rm -r /etc/php7/php-fpm.d

COPY --from=composer /usr/bin/composer /usr/bin/composer
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
