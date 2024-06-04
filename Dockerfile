FROM ubuntu:24.04

ENV TERM=xterm-256color
ENV EDITOR=nano

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
    netcat-traditional \
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
    unzip \
    # Other
    redis-tools \
    ldap-utils && \
    rm -rf /var/lib/apt/lists/*

# Locale setup
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Architecture info
RUN echo "Architecture is $(dpkg --print-architecture)/$(uname -m)"

# yq
RUN ARCH=$(dpkg --print-architecture | sed s/armhf/arm/) && \
    wget -qnv https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${ARCH} -O /usr/bin/yq && \
    chmod +x /usr/bin/yq && \
    yq --version

# grpcurl
ENV GRPCURL_VERSION=1.9.1
RUN ARCH=$(dpkg --print-architecture | sed -e 's/amd64/x86_64/' -e 's/armhf/arm/') && \
    if [ "$ARCH" = "arm" ] ; then exit 0 ; fi && \
    wget -qnv -c https://github.com/fullstorydev/grpcurl/releases/download/v${GRPCURL_VERSION}/grpcurl_${GRPCURL_VERSION}_linux_${ARCH}.tar.gz -O - | tar -xz -C /usr/local/bin/ && \
    chmod +x /usr/local/bin/grpcurl && \
    grpcurl --version

# kubectl
RUN ARCH=$(dpkg --print-architecture | sed -e 's/armhf/arm/') && \
    wget -qnv "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" -O /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client=true

# helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash && \
    helm version

# minio client
RUN ARCH=$(dpkg --print-architecture | sed -e 's/armhf/arm/') && \
    wget -qnv https://dl.min.io/client/mc/release/linux-${ARCH}/mc -O /usr/local/bin/mc && \
    chmod +x /usr/local/bin/mc && \
    mc --version

# xh
ENV XH_BINDIR="/usr/local/bin"
RUN curl -sfL https://raw.githubusercontent.com/ducaale/xh/master/install.sh | sh && \
    xh --version

# oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN echo 'PS1="${fg[red]}[DEBUG-CONTAINER] %(!.%{%F{yellow}%}.)%n@%M ${PS1}"' >> /root/.zshrc
ENV SHELL="/bin/zsh"
ENV HOME="/root"
WORKDIR /root

# etcd
ENV ETCD_VER=v3.5.14
RUN ARCH=$(dpkg --print-architecture | sed -e 's/armhf/arm/') && \
    if [ "$ARCH" = "arm" ] ; then exit 0 ; fi && \
    mkdir -p /tmp/etcd-download && \
    curl -L https://github.com/etcd-io/etcd/releases/download/${ETCD_VER}/etcd-${ETCD_VER}-linux-$(dpkg --print-architecture).tar.gz -o /tmp/etcd.tar.gz && \
    tar xzvf /tmp/etcd.tar.gz -C /tmp/etcd-download --strip-components=1 && \
    rm -f /tmp/etcd.tar.gz && \
    mv /tmp/etcd-download/etcdctl /usr/local/bin/etcdctl && \
    chmod +x /usr/local/bin/etcdctl && \
    mv /tmp/etcd-download/etcdutl /usr/local/bin/etcdutl && \
    chmod +x /usr/local/bin/etcdutl && \
    rm -rf /tmp/etcd-download && \
    etcdctl version && \
    etcdutl version

# aws-cli
RUN ARCH=$(dpkg --print-architecture | sed -e 's/arm64/aarch64/' -e 's/amd64/x86_64/' -e 's/armhf/arm/') && \
    if [ "$ARCH" = "arm" ] ; then exit 0 ; fi && \
    mkdir -p /tmp/aws-cli-download && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH}.zip" -o "/tmp/aws-cli-download/awscliv2.zip" && \
    unzip -q /tmp/aws-cli-download/awscliv2.zip -d /tmp/aws-cli-download && \
    /tmp/aws-cli-download/aws/install && \
    rm -rf /tmp/aws-cli-download && \
    aws --version

CMD ["/bin/zsh"]
