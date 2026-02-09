FROM debian:trixie-slim AS build

ARG SIMUTRANS_VERSION

# 必要なパッケージのインストール。ca-certificatesはwget、curlは./get_lang_files.shの実行のために必要となる
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget unzip autoconf make gcc g++ ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
RUN wget "https://github.com/teamhimeh/simutrans/archive/refs/tags/${SIMUTRANS_VERSION}.zip" && \
    unzip "${SIMUTRANS_VERSION}.zip"

WORKDIR "/tmp/simutrans-${SIMUTRANS_VERSION#v}"
RUN autoupdate && autoconf && ./configure
WORKDIR "/tmp/simutrans-${SIMUTRANS_VERSION#v}/nettools"
RUN make

# ベースイメージ
FROM debian:trixie-slim

ARG SIMUTRANS_VERSION

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

COPY --from=build /tmp/simutrans-${SIMUTRANS_VERSION#v}/nettools/nettool ./nettool/

# TZ環境変数を設定するエントリーポイントスクリプトを配置
COPY entrypoint.sh /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh
RUN chmod +x /app/backup-daily.sh
RUN chmod +x /app/backup-hourly.sh
RUN chmod +x /app/nettool/nettool

# TZ環境変数を設定するためのエントリーポイント
ENTRYPOINT ["/app/entrypoint.sh"]

# cronデーモンをフォアグラウンドで実行
CMD ["cron", "-f"]
