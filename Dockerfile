FROM ubuntu:22.04

ENV TERM=xterm-256color

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get upgrade -y && \
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
    netcat \
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
    rsync \
    gnupg2 \
    # Other
    redis-tools \
    ldap-utils \
    etcd-client

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

# kubectl
RUN wget -nv "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -O /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

# helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# minio client
RUN wget https://dl.min.io/client/mc/release/linux-amd64/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc

# xh
RUN curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | bash

CMD ["/bin/bash"]
