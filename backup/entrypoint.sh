#!/bin/sh
set -e

# compose.ymlで指定したタイムゾーンを使ってcronを動かす
if [ -n "$TZ" ]; then
  echo "Setting timezone to $TZ"
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ > /etc/timezone
fi

exec "$@"
