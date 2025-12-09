#!/bin/bash

cd $(dirname $0)

# セーブをバックアップする
SAVEFILE="daily-$(date +%Y-%m-%d).sve"
echo "\$SAVEFILE=$SAVEFILE"
cp /app/save/server13353-network.sve /app/save/save/$SAVEFILE
