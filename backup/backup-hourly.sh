#!/bin/bash

cd $(dirname $0)

# compose の環境変数を読み込む
. /etc/container.env

echo "Password is: $NETTOOL_PASSWORD"

NETTOOL="/app/nettool/nettool -s host.docker.internal -p $NETTOOL_PASSWORD"

echo "say 60秒後に定期セーブを行います。"
$NETTOOL say "60秒後に定期セーブを行います。"

sleep 50

echo "say まもなくセーブを開始します。"
$NETTOOL say "まもなくセーブを開始します。"

sleep 10

echo "force-sync started."
$NETTOOL force-sync
echo "force-sync command sent."

# 適当なコマンドでforce-syncが終わるまで待機する
$NETTOOL clients
echo "force-sync completed."

# セーブをバックアップする
# 時間をファイル名に含めるので、24時間分のデータが保存される
SAVEFILE="$(date +hourly-%H).sve"
echo "\$SAVEFILE=$SAVEFILE"
cp /app/save/server13353-network.sve /app/save/save/$SAVEFILE
