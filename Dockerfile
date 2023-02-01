FROM ubuntu:22.04

ENV TERM=xterm-256color

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install --no-install-recommends -y \
    # Web
    curl \
    wget \
    httping \
    # Networking
    iputils-ping \
    dnsutils \
    telnet \
    tcpdump \
    traceroute \
    nmap \
    net-tools \
    iproute2 \
    # Security
    ca-certificates \
    openssl \
    openssh-client \
    # Editors
    nano \
    less \
    vim \
    # Development
    git \
    python-setuptools \
    python-pip \
    # Database
    mysql-client \
    postgresql-client \
    influxdb-client \
    # System
    man \
    man-db \
    tmux \
    bash \
    bash-completion \
    locales \
    # Utils
    jq \
    p7zip-full \
    xz-utils \
    gnupg2 \
    # Other
    redis-tools \
    ldap-utils

# Locale setup
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# yq
RUN wget -nv https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq


# grpcurl
RUN wget -nv -c https://github.com/fullstorydev/grpcurl/releases/download/v1.8.7/grpcurl_1.8.7_linux_arm64.tar.gz -O - | tar -xz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/grpcurl

CMD ["/bin/bash"]
