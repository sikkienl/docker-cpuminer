# stage: builder
FROM ubuntu:22.04 as builder
# ARG VERSION_TAG=v25.6

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
FROM ubuntu:22.04

RUN set -x \
  && apt-get update \
  && apt-get install -y \
    build-essential \
    libcurl4 \
    openssl \
    libgmp10 \
    libjansson4 \
    zlib1g

WORKDIR /cpuminer

COPY --from=builder /buildbase/cpuminer-opt/cpuminer ./cpuminer
#COPY --from=builder /buildbase/cpuminer-opt .

LABEL \
  author="SikkieNL (@sikkienl)" \
  type="cpuminer"

ENV ALGOLITHM=""
ENV POOL=""
ENV USER=""
ENV PASS=""
ENV NB_THREADS=1

#ENTRYPOINT /cpuminer --algo=${ALGOLITHM} --url=${POOL} --user=${USER} --threads=${NB_THREADS} --pass=${PASS}
ENTRYPOINT /cpuminer/cpuminer -a ${ALGOLITHM} -o ${POOL} -u ${USER} -p ${PASS} -t ${NB_THREADS}
#ENTRYPOINT /cpuminer -a ${ALGOLITHM} -o ${POOL} -u ${USER} -p ${PASS} -t ${NB_THREADS}
