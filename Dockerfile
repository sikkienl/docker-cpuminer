# stage: builder
FROM alpine:3.17.0 as builder

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
      automake

# Download CPUMiner from scource
WORKDIR /buildbase
RUN set -x \
    && git clone https://github.com/tpruvot/cpuminer-multi.git -b v1.3-multi cpuminer

# Build cpuminer
WORKDIR /buildbase/cpuminer
RUN set -x \
    && bash -x ./autogen.sh \
    # && ./configure CFLAGS="*-march=native*" --with-crypto --with-curl \
    && ./configure --with-crypto --with-curl \
    && make

# stage: release
FROM alpine:3.17.0 as RELEASE

RUN set -x \
    && apk --update --no-cache add \
    libcurl \
    libgcc \
    libstdc++ \
    jansson \
    openssl

WORKDIR /cpuminer

COPY --from=builder /buildbase/cpuminer/cpuminer ./cpuminer

LABEL \
  author="SikkieNL (@sikkienl)" \
  type="cpuminer" \
  miner="cpuminer-multi"

COPY startup.sh .
ENTRYPOINT [ "bash", "startup.sh" ]