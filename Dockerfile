FROM debian:9.5-slim as build-container

ENV VAR_VER=6.0.0

RUN apt update && \
    apt dist-upgrade -y

RUN apt -y install wget gcc make file \
      python-docutils graphviz pkg-config \
      libpcre3-dev libedit-dev && \
    cd ~ && \
    wget https://varnish-cache.org/_downloads/varnish-$VAR_VER.tgz && \
    tar xf varnish-$VAR_VER.tgz && \
    cd varnish-$VAR_VER && \
    ./configure --prefix=/opt/varnish && \
    make -j$(nproc) && \
    make install

FROM debian:9.5-slim

RUN apt update && \
    apt dist-upgrade -y && \
    apt install -y gcc

COPY --from=build-container /opt/varnish /opt/varnish
