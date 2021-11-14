# Code-server: Container Image

## Current Version: PowerShell:`v3.12.0`

Dowonload ---> [[Quay.io](https://quay.io/repository/tnk4on/code-server): [![tnk4on/code-server on Quay.io](https://quay.io/repository/tnk4on/code-server/status "tnk4on/code-server on Quay.io")](https://quay.io/repository/tnk4on/code-server)] or [[Docker.io](https://hub.docker.com/r/tnk4on/code-server)]

[English](README.md) / [Japanese](README_ja.md)

- This repository assumes the use of [Podman](https://github.com/containers/podman) and [Buildah](https://github.com/containers/buildah). If you are using Docker, please read as appropriate.

## Description

- **[code-server](https://github.com/cdr/code-server)** is running VS Code on any machine anywhere and you can access it in the browser.

## About container images

This container image has multiple architectures.
- `tnk4on/code-server:latest`
    - `tnk4on/code-server:amd64`-> linux/amd64 
    - `tnk4on/code-server:arm64`-> linux/arm64 

### Features

- Base Image: ubi8/ubi
- Run as a non-root user. User: `coder` Created.

## How to use

First, create directories for code-server.
```
$ mkdir -p code-server/project code-server/local code-server/config
$ tree
.
└── code-server
    ├── config
    ├── local
    └── project
```

Go to the code-server directory and run the container.
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


## Use .bashrc, .gitconfig, .git-credentials
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

## How to build container image

```
git clone https://github.com/tnk4on/code-server.git
cd code-server
podman build -t tnk4on/code-server:amd64 . --build-arg ARCH=amd64
podman build -t tnk4on/code-server:arm64 . --build-arg ARCH=arm64 --arch arm64
```
Note: Default arch is amd64.
