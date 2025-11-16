# stage: builder
FROM ubuntu:bionic as builder

# Update OS
RUN set -x \
  && apt-get update \
  && apt-get upgrade

# Install Dependencies
RUN set -x \
  && apt-get install -y \
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

WORKDIR /buildbase
RUN set -x \
  && git clone https://github.com/JayDDee/cpuminer-opt -b v25.6

# Build cpuminer
WORKDIR /buildbase/cpuminer-opt
RUN set -x \
# RUN ./autogen.sh \
  && bash -x ./autogen.sh \
  && extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores" \
  && CFLAGS="-O3 -march=native -Wall" ./configure --with-curl  \
  && make install -j 4

# App
FROM ubuntu:bionic

RUN set -x \
  && apt-get update \
  && apt-get install -y \
    build-essential \
    libcurl4 \
    openssl \
    libgmp10 \
    libjansson4 \
    zlib1g \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /cpuminer

#COPY --from=builder /buildbase/cpuminer-opt/cpuminer ./cpuminer
COPY --from=builder /buildbase/cpuminer-opt .

LABEL \
  author="SikkieNL (@sikkienl)" \
  type="cpuminer"

COPY startup.sh .
ENTRYPOINT [ "bash", "startup.sh" ]