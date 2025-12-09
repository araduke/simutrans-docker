
# Dockerを使ったSimutrans-Extendedサーバーのセットアップ

(あくまでSimutrans-Extended向けに作成していますが、修正を加えればStandard版やOTRP版でも動作すると思います)

- command-line-server-build(GUI無し)バージョンのSimutrans-Extendedに対応
- オートセーブ・毎時/毎日セーブに対応
  - 毎時セーブは直近24時間分、毎日セーブは無制限に保存されます

## 0. 事前にインストールが必要なもの

以下のソフトウェアがインストールされている必要があります。OSはLinux系を想定しています。WindowsやMacで動くかは未確認です。

1. Docker
2. Docker Compose

## 1. 実行ファイルの用意

1. このリポジトリをクローンするか、緑の「Code」ボタンを押して`Download ZIP`でダウンロードし、解凍して下さい。
2. このフォルダを使ってサーバーを立てるので、適当に良さそうな場所に配置して下さい。フォルダ名は変更しても構いません。
3. このフォルダに`volume-bin`フォルダと`volume-nettool`フォルダを作成して下さい。
4. https://bridgewater-brunel.me.uk/downloads/nightly/packages/ から`Simutrans-Extended-Complete.zip`をダウンロードして解凍し、`volume-bin`フォルダに配置して下さい。
    - この最新版の本体をベースに参加者向けの配布用クライアントを作成します。
    - 使用しないpaksetなどの不要なファイルを削除しても構いません。
5. https://bridgewater-brunel.me.uk/downloads/nightly/linux-x64/ から`nettool`をダウンロードして`volume-nettool`フォルダに配置して下さい。
6. `volume-nettool/nettool`に実行権限を付与して下さい。コマンドラインで`chmod u+x volume-nettool/nettool`を実行してください。
7. 正しく配置できているかチェックして下さい。
    - `README.md`があるフォルダに`volume-bin`フォルダがあり、その中に`simutrans-extended`という実行ファイルがあればOKです。
    - `README.md`があるフォルダに`volume-nettool`フォルダがあり、その中に`nettool`という実行ファイルがあればOKです。
8. `simuconf.tab`の設定の`singleuser_install`が0になっていることを確認して下さい。
    - ダウンロードしてそのままの場合は0になっていますが、他の場所からコピーしてきた場合は1になっている可能性があります。0に変更して下さい。

最新のNightlyバージョンではなく、事前に用意した特定のバージョンを使いたい場合は適宜4.の手順を変更して下さい。なお、nettoolはほとんど変わらないので最新版を使って問題ありません。

Simutrans-Extendedには安定版が存在しません。そのため、Nightlyビルドを頻繁に更新することは避けた方が良いでしょう。大きな変更が取り込まれてしばらくの間はNightlyビルドが不安定になることがあります。

## 2. セーブデータの配置

セーブデータをあらかじめ生成しておく必要があります。同じ本体を使ってセーブデータを生成した場合は2.aを、異なるバージョンの本体を使ってセーブデータを生成した場合は2.bを参照して下さい。

ちなみに、サーバーに接続したときのクライアント側のマップ位置はセーブデータを生成したときのセーブ位置になります。

### 2.a まったく同じバージョンのデータを持ってくる場合

1. このフォルダに`volume-save`フォルダと`volume-save/save`フォルダを作成して下さい。
    - `mkdir -p volume-save/save`で一気に作成できます。
2. 事前に作成したセーブデータを`volume-save/server13353-network.sve`というファイル名でコピーして下さい。

### 2.b 他バージョンのデータを持ってくる場合

1. このフォルダに`volume-save`フォルダと`volume-save/save`フォルダを作成して下さい。
    - `mkdir -p volume-save/save`で一気に作成できます。
2. 事前に作成したセーブデータを`volume-save/save/first.sve`というファイル名でコピーして下さい。
3. `sudo docker compose up first`を実行して、ログが止まるまで待ちます。このとき、実行を中断しないで下さい。
4. 同じバージョンの本体を手元の端末で起動し、サーバーに接続して下さい。
5. ロードが終わり、ゲーム内時間が進み始めたら、セーブデータが変換され、適切な位置に保存されました。自身の端末の本体を閉じ、`sudo docker compose up first`で動かしたコンテナを`Ctrl+C`で停止して下さい。
6. 後始末として、`sudo docker compose down first`を実行してコンテナを削除して下さい。

## 3. サーバー構築

GUIのない軽量な本体でサーバーを構築する場合(おすすめ)は3.aを、GUI付きの本体でサーバーを構築する場合は3.bを、VNCを使ってサーバー自体を操作する場合は3.cを参照して下さい。

### 3.a command-line-server-build(GUI無し版)で構築する場合

1. https://bridgewater-brunel.me.uk/downloads/nightly/linux-x64/command-line-server-build/ からGUI無し版の`simutrans-extended`をダウンロードし、`volume-bin`フォルダに`headless-server`という名前で配置して下さい。
2. `volume-bin/headless-server`に実行権限を付与して下さい。コマンドラインで`chmod u+x volume-bin/headless-server`を実行してください。
3. `.env`ファイルを開き、`nettool`用のパスワードを設定して下さい。
4. `sudo docker compose up -d server-headless backup`を実行してサーバーとバックアップコンテナの両方を起動して下さい。

### 3.b GUIあり版で構築する場合

1. `.env`ファイルを開き、`nettool`用のパスワードを設定して下さい。
2. `sudo docker compose up -d server-general backup`を実行してサーバーとバックアップコンテナの両方を起動して下さい。

### 3.c GUIあり版にVNC接続できるようにして構築する場合

1. `.env`ファイルを開き、`nettool`用のパスワードを設定して下さい。
2. `sudo docker compose up -d server-vnc backup`を実行してサーバーとバックアップコンテナの両方を起動して下さい。
3. VNCクライアントを使ってサーバーに接続して下さい。サーバーと同じマシンであれば、`localhost`(ポートはデフォルトと同じ5900番)に接続すれば良いです。別のマシンから接続する場合は、サーバーのホスト名またはIPアドレスを指定して下さい。

## Tips

### 最新のセーブデータの場所

- `volume-save/server13353-network.sve`に最新のセーブデータがあります。

### GUI無し版でサーバーを立てると、クライアントを置いてけぼりにする問題

GUI無し版でサーバーを立てると、クライアントの処理が置いてけぼりになることがあります。GUI無しの本体では、描画処理が存在しない分サーバーの処理が高速になります。その結果、クライアント側の処理が追いつかず、ユーザーの操作が反映されるまでに数十秒かかりプレイ不可能になることがあります(なりました)。

この問題を解決するために、`server-headless`の設定ではCPU使用率を70%に制限しています。これにより、クライアント側の処理が追いつきやすくなります。ただし、サーバーの処理が遅くなるため、サーバー側での時間進行が遅くなります。

この値は弊鯖での経験に基づいて設定していますが、環境によっては調整が必要かもしれません。`docker-compose.yml`の`server-headless`セクションの`cpus`の値を変更して試してみて下さい。

### サーバーのログを見る

- `sudo docker compose logs -fn 100`で最新100行のログをリアルタイムで確認できます。

### サーバーの停止

1. 手元の端末でSimmutrans-Extendedのクライアントを立ち上げ、サーバーに接続して下さい。この接続時の操作でセーブが行われます。
2. `sudo docker compose down`ですべてのコンテナを停止します。再度立ち上げる際には`backup`コンテナも一緒に立ち上げて下さい。

### Rootless Dockerで動かしたい

`backup/backup-hourly.sh`で`host.docker.internal`を使っている部分を、使用するサービス名に変更し、`docker-compose.yml`の`backup`セクションの`extra_hosts`を削除して下さい。

### libminiupnpc.17について

```Dockerfile
# libminiupnpc.17が必要なので、誤魔化す
RUN ln -s /usr/lib/x86_64-linux-gnu/libminiupnpc.so.18 /usr/lib/x86_64-linux-gnu/libminiupnpc.so.17 && \
    ldconfig
```

動いてるからヨシッ！

## 参考資料

- [Simutrans OTRPのHeadlessサーバーを建てるのに苦労した話 #game - Qiita](https://qiita.com/YutaGameMusic/items/f8f3e6f89290e5a2e9d1#%E3%83%93%E3%83%AB%E3%83%89%E3%81%A8%E5%88%9D%E5%9B%9E%E3%83%AD%E3%83%BC%E3%83%89)
  - OTRPバージョンでGUI込みでのサーバー構築方法が解説されています。
- [How to set-up (or compile) a Linux headless Simutrans server?](https://forum.simutrans.com/index.php?topic=23231.0)
  - Standard版などでGUI無しのバイナリをコンパイルする方法が解説されています。
