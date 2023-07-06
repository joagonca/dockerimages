FROM golang:1.18 AS builder
WORKDIR /go/src/ProtonMail/

RUN apt-get update \
	&& apt-get install -y --no-install-recommends libsecret-1-dev

RUN git clone -b v3.3.0 https://github.com/ProtonMail/proton-bridge.git \
	&& cd proton-bridge \
	&& make build-nogui

FROM debian:buster
RUN apt-get update \
	&& apt-get install -y --no-install-recommends socat pass ca-certificates libsecret-1-0 \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /app/
COPY gpgparams ./

COPY init ./
RUN chmod +x init

COPY start ./
RUN chmod +x start

COPY --from=builder /go/src/ProtonMail/proton-bridge/bridge ./
RUN chmod +x bridge

EXPOSE 143/tcp
EXPOSE 25/tcp

