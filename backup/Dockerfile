# ベースイメージ
FROM debian:trixie-slim

# cronパッケージのインストール
RUN apt-get update && \
    apt-get install -y cron && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 作業ディレクトリの設定
WORKDIR /app

# バックアップスクリプトを配置
COPY backup-hourly.sh /app/backup-hourly.sh
COPY backup-daily.sh /app/backup-daily.sh

# crontabの設定
COPY crontab /etc/cron.d/backup-cron
RUN chmod 0644 /etc/cron.d/backup-cron && \
    crontab /etc/cron.d/backup-cron

# TZ環境変数を設定するエントリーポイントスクリプトを配置
COPY entrypoint.sh /app/entrypoint.sh

# TZ環境変数を設定するためのエントリーポイント
ENTRYPOINT ["/app/entrypoint.sh"]

# cronデーモンをフォアグラウンドで実行
CMD ["cron", "-f"]
