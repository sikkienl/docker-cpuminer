# stage: builder
FROM debian:trixie-slim

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
  && apt-get remove -y \
    autoconf \
    automake \
    build-essential \
    curl \
    g++ \
    git \
    make \
    pkg-config \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \

# Verify
  && cpuminer --cputest \
  && cpuminer --version 

LABEL \
  author="SikkieNL (@sikkienl)" \
  type="cpuminer"

COPY startup.sh .
ENTRYPOINT [ "bash", "startup.sh" ]