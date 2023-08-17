# Proton-Bridge Dockerfile

This is a multistage Dockerfile to build proton-bridge. This dockerfile is designed to be executed in a Raspberry Pi 4 (arm64), but should work elsewhere.

## Build

```
$ docker build --platform arm64v8 <image_name> .
```

## Configure

```
$ docker run --rm -it -v <local_protonbridge_folder>:/root <image_name> ./init
```

## Run

```
$ docker run -d --name proton-bridge --restart unless-stopped -p 1025:25/tcp -p 1143:143/tcp -v <local_protonbridge_folder>:/root <image_name> ./start
```