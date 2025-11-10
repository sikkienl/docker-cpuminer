FROM ubuntu:bionic

LABEL author="SikkieNL (@sikkienl)"

### Install Dependencies
RUN apt-get update -y && \
	apt-get upgrade -y

RUN apt-get install -y build-essential automake libssl-dev libcurl4-openssl-dev libjansson-dev libgmp-dev zlib1g-dev git gcc make && \
  autoconf pkg-config && \
#  rm -rf /var/lib/apt/lists/*

### Build CPU Miner			
RUN git clone https://github.com/tpruvot/cpuminer-multi -b linux cpuminer && \
  cd cpuminer && && ./build.sh

### Entrypoint Setup
WORKDIR /cpuminer
ENTRYPOINT	["./cpuminer"]