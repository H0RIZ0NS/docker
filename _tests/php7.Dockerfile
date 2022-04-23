########################################################################

FROM tests/php:7-base AS cli

CMD \
  set -x && \
  [ "$(whoami)" = 'php' ] && \
  [ "$(pwd)" = '/opt/app' ] && \
  php --version && \
  composer --version

########################################################################

FROM tests/php:7-fpm-base AS fpm

CMD \
  set -x && \
  [ "$(whoami)" = 'php' ] && \
  [ "$(pwd)" = '/opt/app' ] && \
  php --version && \
  php-fpm7 --version && \
  composer --version

########################################################################
