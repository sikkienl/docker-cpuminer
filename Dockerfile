FROM ubuntu:bionic

LABEL author="SikkieNL (@sikkienl)"

### Install Dependencies
RUN apt-get update -y && \
	apt-get upgrade -y

RUN apt-get install -y \
  build-essential \
  autoconf \
  automake \
  libtool \
  pkg-config \
  libcurl4-gnutls-dev \
	uthash-dev \
  libncursesw5-dev \
  git

### Build CPU Miner			
RUN git clone https://github.com/ghostlander/nsgminer && \
  cd nsgminer && ./autogen.sh && make

### Entrypoint Setup
WORKDIR /nsgminer
ENTRYPOINT	["./nsgminer"]
CMD ["-h"]