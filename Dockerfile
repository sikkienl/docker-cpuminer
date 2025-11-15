FROM ubuntu:bionic

LABEL author="SikkieNL (@sikkienl)"
ARG VERSION_TAG=v25.6

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
  libcurl4-openssl-dev \
  libgmp-dev \
  libjansson-dev \
  libssl-dev \
  libz-dev \
  make \
  pkg-config \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Download CPUMiner from scource
RUN git clone https://github.com/JayDDee/cpuminer-opt /cpuminer

# Build cpuminer
RUN cd cpuminer \
  && git checkout "$VERSION_TAG" \
  && ./autogen.sh \
  && extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores" \
  && CFLAGS="-O3 -march=native -Wall" ./configure --with-curl  \
  && make install -j 4 \
   && cd / 

WORKDIR /cpuminer
ADD config.json /cpuminer
EXPOSE 4048
CMD ["cpuminer", "--config=config.json"]
