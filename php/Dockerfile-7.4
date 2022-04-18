########################################################################

FROM composer:2.2.6 AS composer

########################################################################

FROM alpine:3.15.4

LABEL \
  org.opencontainers.image.authors="Fabien Schurter <dev@fabschurt.com>" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.source="https://github.com/H0RIZ0NS/docker"

STOPSIGNAL SIGQUIT

RUN \
  apk add --no-cache \
    php7=7.4.28-r0 \
    php7-fpm=7.4.28-r0

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
