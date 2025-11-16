# stage: builder
FROM alpine:3.17.0 as builder

# Install Dependencies
RUN set -x \
    && apk --update --no-cache add \
    build-base \
    git \
    libcurl \
    curl-dev \
    jansson-dev \
    bash \
    autoconf \
    openssl-dev \
    make \
    automake \

# Download CPUMiner from scource
&& git clone https://github.com/JayDDee/cpuminer-opt -b v25.6 /cpuminer \
#&& git clone https://github.com/tpruvot/cpuminer-multi.git -b v1.3-multi cpuminer \

# Build cpuminer
&& cd /cpuminer \
&& ./autogen.sh \
&& extracflags="$extracflags -Ofast -flto -fuse-linker-plugin -ftree-loop-if-convert-stores" \
&& CFLAGS="-O3 -march=native -Wall" ./configure --with-curl  \
&& make install -j 4

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