FROM ubuntu:bionic

LABEL author="SikkieNL (@sikkienl)"

### Install Dependencies
RUN apt-get update && \
	apt-get install -y software-properties-common && \
  add-apt-repository ppa:bitcoin/bitcoin

RUN apt-get install -y git \
    build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils \
    libgmp-dev \
    libcurl4-openssl-dev \
    libjansson-dev &&\
    apt-get clean

### Build CPU Miner			
  run git clone https://github.com/JayDDee/cpuminer-opt && \
    cd cpuminer-opt && \
    ./autogen.sh && \
    CFLAGS="-O3 -march=native -Wall" ./configure --with-curl && \
    make -j n

### Entrypoint Setup
  WORKDIR /cpuminer