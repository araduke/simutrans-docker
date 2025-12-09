#!/bin/sh
set -e

# タイムゾーン適用
if [ -n "$TZ" ]; then
  echo "Setting timezone to $TZ"
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
  echo $TZ > /etc/timezone
fi

# compose.yml で渡された環境変数をファイル化
echo "Saving environment variables to /etc/container.env"
env | grep -E '^(NETTOOL_PASSWORD|TZ)=' > /etc/container.env

exec "$@"
