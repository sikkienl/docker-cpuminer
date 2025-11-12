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
  && apt-get clean

# Build CPU Miner from scource code
RUN git clone https://github.com/JayDDee/cpuminer-opt && \
  cd cpuminer-opt && \
  git checkout "$VERSION_TAG" && \
  ./autogen.sh && \
  CFLAGS="-O3 -march=native -Wall" ./configure --with-curl && \
  make install -j 4

  # Clean-up
RUN cd / && \
apt-get purge --auto-remove -y \
  autoconf \
  automake \
  curl \
  g++ \
  git \
  make \
  pkg-config \
  && apt-get clean

  # Verify
RUN cpuminer --cputest && \
cpuminer --version

### Entrypoint Setup
WORKDIR /cpuminer
COPY config.json /cpuminer
EXPOSE 80
CMD ["cpuminer", "--config=config.json"]