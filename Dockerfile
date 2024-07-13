# License-Identifier: (MIT)
FROM ubuntu:22.04

LABEL maintainer="SystemsBR"
LABEL version="1.0"
LABEL description="Crosscompiller tool for raspberrypi"

ARG DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && apt-get -y install --no-install-recommends \
    sudo tzdata locales wget unzip rsync bc ca-certificates openssl \
    bc bison flex libssl-dev libc6-dev libncurses5-dev git wget unzip \
    crossbuild-essential-armhf crossbuild-essential-arm64 \
    gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
    libstdc++6-armhf-cross libc6-dev-armhf-cross \
    build-essential make cmake \
    && apt-get clean

# Configure Timezone
ENV TZ=Etc/UTC
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN \
    ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    echo "Etc/UTC" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    locale-gen en_US.UTF-8

# User setup
ENV USER=builder
ENV HOME=/home/${USER}
ENV WORK=/project

ARG HOST_UID=1000
ARG HOST_GID=1000

RUN \
    groupadd -g ${HOST_GID} ${USER} && \
    useradd -g ${HOST_GID} -m -s /bin/bash -u ${HOST_UID} ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USER} && \
    chmod 0440 /etc/sudoers.d/${USER}

RUN usermod -aG sudo ${USER} 

# Setup passwords
RUN echo "root:rootpass" > /root/passwdfile
RUN echo "${USER}:builderpass" >> /root/passwdfile
RUN chpasswd -c SHA512 < /root/passwdfile && \
    rm /root/passwdfile

USER ${USER}

# Configure basic .gitconfig
RUN \
    git config --global color.ui false && \
    git config --global http.sslverify false

WORKDIR ${WORK}

ENTRYPOINT ["/bin/bash"]
