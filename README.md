# Dockerを使ったSimutrans OTRPサーバーのセットアップ

Simutrans(OTRP)のマルチプレイサーバーをDockerを使って構築・運用するための設定ファイル群です。

## 注意事項

- **現在は `server-headless` と `backup` サービスのみが正常稼働します。**
- `server-general` および `server-vnc` は現在正常に動作しません。
- デフォルトでは [teamhimeh/simutrans](https://github.com/teamhimeh/simutrans) (OTRP) をベースにビルドされます。

## 特徴

- サーバー本体の自動ビルド（Docker内で行われるため、バイナリの事前用意は不要）
- オートセーブ・バックアップ機能（毎時/毎日）
  - 毎時セーブは直近24時間分、毎日セーブは無制限に保存されます

## 0. 事前にインストールが必要なもの

- Docker
- Docker Compose

## 1. 設定とファイルの用意

### .env の設定
`.env` ファイルを開き、以下の項目を設定してください。
- `NETTOOL_PASSWORD`: サーバー管理用パスワード（必ず変更してください）
- `SIMUTRANS_VERSION`: ビルドするSimutransのタグ名（例: `v51_1_1`）
- `PORT`: 待ち受けポート（デフォルト: `13353`）

### ディレクトリの準備と配置
以下の構造に従って、必要なファイルを配置してください。

- `volume-bin/pak/`: 使用する pakset（例: `pak.nippon` の中身など）を配置してください。
- `volume-save/`: 
    - 起動時に読み込むセーブデータを `server13353-network.sve` という名前で配置してください。
    - `save/` ディレクトリを作成しておいてください（バックアップがここに保存されます）。

## 2. サーバーの起動

以下のコマンドを実行して、headlessサーバーとバックアップサービスを起動します。

```bash
docker compose up -d server-headless backup
```

## Tips

### ログの確認
サーバーの動作状況を確認するには、以下のコマンドを使用します。

```bash
docker compose logs -f server-headless
```

### サーバーの停止
コンテナを停止・削除するには以下のコマンドを実行します。

```bash
docker compose down
```

### バックアップの仕組み
`backup` コンテナが稼働している間、`backup/backup-hourly.sh` および `backup/backup-daily.sh` が定期的に実行され、`volume-save/save/` 内にセーブデータのコピーが作成されます。
