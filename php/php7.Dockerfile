########################################################################

FROM composer:2.2.6 AS composer

########################################################################

FROM alpine:3.15.4 AS base

LABEL \
  org.opencontainers.image.authors="Fabien Schurter <dev@fabschurt.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

RUN \
  apk add --no-cache \
    php7=7.4.28-r0 \
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

COPY config/php.ini /etc/php7/php.ini
COPY --from=composer /usr/bin/composer /usr/bin/composer

########################################################################

FROM base AS cli

ONBUILD ARG RUNTIME_USER_ID=1000

ONBUILD RUN \
  adduser -u ${RUNTIME_USER_ID} -D -s /sbin/nologin php && \
  mkdir /opt/app && \
  chown -R php:php /opt/app

ONBUILD WORKDIR /opt/app
ONBUILD USER php

########################################################################

FROM base AS fpm

CMD ["php-fpm7"]
STOPSIGNAL SIGQUIT

EXPOSE 9000

RUN apk add --no-cache php7-fpm=7.4.28-r0

COPY config/php-fpm.conf /etc/php7/php-fpm.conf

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
