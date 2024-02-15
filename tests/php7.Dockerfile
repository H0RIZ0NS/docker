FROM tests/php:7-base

CMD \
  set -x && \
  [ "$(whoami)" = 'php' ] && \
  [ "$(pwd)" = '/opt/app' ] && \
  php --version && \
  php-fpm --version && \
  composer --version
