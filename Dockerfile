FROM ubuntu:22.04
LABEL author="SikkieNL (@sikkienl)"
ARG VERSION_TAG=v25.6

# Install Dependencies
RUN apt-get update -y && \
    apt-get install -y \
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
RUN git clone https://github.com/JayDDee/cpuminer-opt /cpuminer

# Build cpuminer
RUN cd cpuminer \
  && git checkout "$VERSION_TAG" \
  && ./autogen.sh \
  && extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores" \
  && CFLAGS="-O3 -march=native -Wall" ./configure --with-curl  \
  && make install -j 4 \
  && cd / \
  # Verify
  && cpuminer --cputest \
  && cpuminer --version

WORKDIR /cpuminer
#ADD config.json /cpuminer
#EXPOSE 4048
#CMD ["cpuminer", "--config=config.json"]
ENTRYPOINT	["./cpuminer"]
CMD ["-h"]