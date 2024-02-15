FROM tests/node:16-base

CMD \
  set -x && \
  [ "$(whoami)" = 'node' ] && \
  [ "$(pwd)" = '/opt/app' ] && \
  node --version && \
  npm --version
