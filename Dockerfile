# stage: builder
FROM ubuntu:bionic

RUN set -x \
  # Update OS
  && apt-get update \
  && apt-get upgrade -y \

  # Build dependencies.
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

# Download CPUMiner from scource
  && git clone https://github.com/JayDDee/cpuminer-opt -b v25.6 /cpuminer \

# Build cpuminer
  && cd /cpuminer \
  && ./autogen.sh \
  && extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores" \
  && CFLAGS="-O3 -march=native -Wall" ./configure --with-curl  \
  && make install -j 4 \

# Clean-up
  && cd / \
  && apt-get purge --auto-remove -y \
    autoconf \
    automake \
    curl \
    g++ \
    git \
    libcurl4-openssl-dev \
    libjansson-dev \
    libssl-dev \
    libgmp-dev \
    make \
    pkg-config \

# Verify
  && cpuminer --cputest \
  && cpuminer --version 

LABEL \
  author="SikkieNL (@sikkienl)" \
  type="cpuminer"

COPY startup.sh .
ENTRYPOINT [ "bash", "startup.sh" ]