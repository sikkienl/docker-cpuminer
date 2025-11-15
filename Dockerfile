# stage: builder
FROM ubuntu:22.04 as builder
ARG VERSION_TAG=v25.6

# Install Dependencies
RUN set -x \
  && apt-get update \
  && apt-get upgrade \
  && apt-get install -y \
    autoconf \
    automake \
    build-essential \
    git \
    libcurl4-openssl-dev \
    libgmp-dev \
    libjansson-dev \
    libssl-dev \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Download CPUMiner from scource

WORKDIR /buildbase
RUN set -x \
  && git clone https://github.com/JayDDee/cpuminer-opt -b ${VERSION_TAG} /cpuminer

# Build cpuminer
WORKDIR /buildbase/cpuminer
RUN ./autogen.sh \
  && extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores" \
  && CFLAGS="-O3 -march=native -Wall" ./configure --with-curl  \
  && make install -j 4

# App
FROM ubuntu:22.04 as release

RUN set -x \
  && apt-get update \
  && apt-get install -y \
    libcurl4 \
    openssl \
    libgmp10 \
    libjansson4 \
    zlib1g

WORKDIR /cpuminer

COPY --from=builder /buildbase/cpuminer/cpuminer ./cpuminer

LABEL \
  author="SikkieNL (@sikkienl)" \
  type="cpuminer"

ENV ALGOLITHM=""
ENV THREADS=1
ENV USER=""
ENV PASSWORD=""
ENV URL=""

ENTRYPOINT /cpuminer/cpuminer --algo=${ALGOLITHM} --url=${URL} --user=${USER} --threads=${THREADS} --pass=${PASSWORD}
