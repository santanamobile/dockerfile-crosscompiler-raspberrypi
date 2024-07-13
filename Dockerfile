# License-Identifier: (MIT)
FROM ubuntu:22.04

LABEL maintainer="SystemsBR"
LABEL version="1.0"
LABEL description="Crosscompiller tool for raspberrypi"

ARG DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && apt-get -y install --no-install-recommends \
    sudo tzdata locales wget unzip rsync bc ca-certificates openssl \
    bc bison flex libssl-dev libc6-dev libncurses5-dev \
    build-essential make cmake \
    crossbuild-essential-armhf \
    crossbuild-essential-arm64 \
    gcc-arm-linux-gnueabihf \
    g++-arm-linux-gnueabihf \
    libstdc++6-armhf-cross \
    libc6-dev-armhf-cross \
    git wget unzip \
    && apt-get clean

WORKDIR /workspace

# Configure Timezone
ENV TZ=Etc/UTC
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    echo "Etc/UTC" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    locale-gen en_US.UTF-8

ENTRYPOINT ["/bin/bash"]
