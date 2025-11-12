FROM ubuntu:bionic

LABEL author="SikkieNL (@sikkienl)"

# Runtime dependencies
RUN apt-get update -y && \
	apt-get upgrade -y

# Install Dependencies
RUN apt-get install -y \
  autoconf \
  automake \
  build-essential \
  curl \
  g++ \
  git \
  libtool \
  pkg-config \
  libcurl4-gnutls-dev \
	uthash-dev \
  libncursesw5-dev \
  make

### Build CPU Miner			
RUN git clone https://github.com/ghostlander/nsgminer && \
  cd nsgminer && ./autogen.sh && make

### Entrypoint Setup
WORKDIR /nsgminer
#ENTRYPOINT	["./nsgminer"]
CMD ["nsgminer"]