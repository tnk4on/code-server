# Code-server: Container Image

## Current Version: PowerShell:`v3.12.0`

Dowonload ---> [[Quay.io](https://quay.io/repository/tnk4on/code-server): [![tnk4on/code-server on Quay.io](https://quay.io/repository/tnk4on/code-server/status "tnk4on/code-server on Quay.io")](https://quay.io/repository/tnk4on/code-server)] or [[Docker.io](https://hub.docker.com/r/tnk4on/code-server)]

[English](README.md) / [Japanese](README_ja.md)

- このリポジトリでは[Podman](https://github.com/containers/podman)と[Buildah](https://github.com/containers/buildah)での使用を前提として記載しています。Dockerをお使いの場合は適宜読み替えてください。

## 概要

- **[code-server](https://github.com/cdr/code-server)** どこでもどんなマシンでもVS Codeを走らせ、ブラウザでアクセスすることができます。

## コンテナイメージについて

このコンテナイメージは、複数のアーキテクチャに対応しています
- `tnk4on/code-server:latest`
    - `tnk4on/code-server:amd64`-> linux/amd64 
    - `tnk4on/code-server:arm64`-> linux/arm64 

### 機能の特徴

- ベースイメージ: ubi8/ubi
- 非rootユーザーで実行。ユーザー: `coder` 作成済み。

## 使い方

最初にcode-serverのためのディレクトリを作成します
```
$ mkdir -p code-server/project code-server/local code-server/config
$ tree
.
└── code-server
    ├── config
    ├── local
    └── project
```

code-serverディレクトリに移動し、コンテナを実行します
```
cd code-server
podman run -d --name code-server \
-v ./project:/home/coder/project:rw,z \
-v ./local:/home/coder/.local:rw,z \
-v ./config:/home/coder/.config:rw,z \
--userns=keep-id \
-e PASSWORD=your-pass-word \
-e TZ=Asia/Tokyo \
-p 8080:8080 \
tnk4on/code-server
```
Note: Use `--userns=keep-id` because it will be run by a user with a different UID/GID in the container.


## .bashrc, .gitconfig, .git-credentials を使う
```
cd code-server
podman run -d --name code-server \
-v ./project:/home/coder/project:rw,z \
-v ./local:/home/coder/.local:rw,z \
-v ./config:/home/coder/.config:rw,z \
-v ./bashrc:/home/coder/.bashrc:rw,z \
-v ~/.gitconfig:/home/coder/.gitconfig:ro,z \
-v ~/.git-credentials:/home/coder/.git-credentials:ro,z \
--userns=keep-id \
-e PASSWORD=your-pass-word \
-e TZ=Asia/Tokyo \
-p 8080:8080 \
tnk4on/code-server
```

## コンテナイメージのビルド方法

```
git clone https://github.com/tnk4on/code-server.git
cd code-server
podman build -t tnk4on/code-server:amd64 . --build-arg ARCH=amd64
podman build -t tnk4on/code-server:arm64 . --build-arg ARCH=arm64 --arch arm64
```
Note: デフォルトのアーキテクチャーはamd64です
