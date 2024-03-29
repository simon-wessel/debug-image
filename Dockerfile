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
    zsh \
    locales \
    # Utils
    jq \
    p7zip-full \
    xz-utils \
    rsync \
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
RUN wget -nv -c https://github.com/fullstorydev/grpcurl/releases/download/v1.8.9/grpcurl_1.8.9_linux_arm64.tar.gz -O - | tar -xz -C /usr/local/bin/ && \
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
ENV XH_BINDIR="/usr/local/bin"
RUN curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh

# oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN echo 'PS1="${fg[red]}[DEBUG-CONTAINER] %(!.%{%F{yellow}%}.)%n@%M ${PS1}"' >> /root/.zshrc
ENV SHELL="/bin/zsh"
ENV HOME="/root"
WORKDIR /root

# etcd
ENV ETCD_VER=v3.5.11
RUN mkdir -p /tmp/etcd-download && \
    curl -L https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz && \
    tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-download --strip-components=1 && \
    rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz && \
    mv /tmp/etcd-download/etcdctl /usr/local/bin/etcdctl && \
    mv /tmp/etcd-download/etcdutl /usr/local/bin/etcdutl && \
    rm -rf /tmp/etcd-download

CMD ["/bin/zsh"]
