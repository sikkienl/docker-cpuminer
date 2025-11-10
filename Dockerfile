#FROM alpine:latest
FROM ubuntu:bionic
MAINTAINER SikkieNL

### Set Environment Variables
   ENV ENABLE_SMTP=FALSE

### Install Dependencies
   RUN  adduser -S -D -H -h /mine mine && \
    apk update && \
		apk add \
			automake \
			autoconf \
		  openssl-dev \
			curl-dev \
			git \
			build-base && \
      libssl-dev \
      libcurl4-openssl-dev \
      libjansson-dev \
      libgmp-dev \
      zlib1g-dev \

### Build CPU Miner			
  git clone https://github.com/JayDDee/cpuminer-opt && \
  cd cpuminer-opt && \
	./autogen.sh && \
	CFLAGS="-O3 -march=native -Wall" ./configure --with-curl && \
	make -j n && \

### Cleanup
  apk del \
    automake \
    autoconf \
    build-base \
    git && \
    libssl-dev \
    libcurl4-openssl-dev \
    libjansson-dev \
    libgmp-dev \
    zlib1g-dev \
    rm -rf /var/cache/apk/* /usr/src/*

### Add Files
   ADD install /

### Entrypoint Setup
   WORKDIR /cpuminer-opt