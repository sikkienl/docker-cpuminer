# stage: builder
FROM alpine:3.17.0 as builder

# Install Dependencies

# Runtime dependencies.
RUN set -x \
    && apk add --no-cache \
    libcurl \
    libgcc \
    libstdc++ \
    openssl

# Build dependencies.   
RUN set -x \
    && apk add --no-cache .build-deps \
    autoconf \
    automake \
    build-base \
    curl \
    curl-dev \
    git \
    openssl-dev

# Download CPUMiner from scource
WORKDIR /buildbase
RUN set -x \
    #&& git clone https://github.com/JayDDee/cpuminer-opt -b v25.6
    && git clone https://github.com/tpruvot/cpuminer-multi.git -b v1.3-multi cpuminer

# Build cpuminer
WORKDIR /buildbase/cpuminer
RUN set -x \
    && bash -x ./autogen.sh \
    #&& extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores" \
    && ./configure CFLAGS="-O2 -march=native " --with-crypto --with-curl  \
    && make install

# App
FROM alpine:3.17.0

RUN set -x \
    && apk --update --no-cache add \
    libcurl \
    libgcc \
    libstdc++ \
    jansson \
    openssl

WORKDIR /cpuminer

#COPY --from=builder /buildbase/cpuminer-opt/cpuminer ./cpuminer
COPY --from=builder /buildbase/cpuminer .

LABEL \
  author="SikkieNL (@sikkienl)" \
  type="cpuminer"

COPY startup.sh .
ENTRYPOINT [ "bash", "startup.sh" ]