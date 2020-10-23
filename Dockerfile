FROM ubuntu:focal
MAINTAINER danielpops@gmail.com

RUN apt-get update > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        bison \
        cmake \
        curl \
        doxygen \
        g++ \
        gcc \
        git-core \
        gnutls-bin \
        graphviz \
        libical-dev \
        libldap2-dev \
        libgcrypt20-dev \
        libglib2.0-dev \
        libgpgme-dev \
        libhiredis-dev \
        libksba-dev \
        libmicrohttpd-dev \
        libpcap-dev \
        libpq-dev \
        libsnmp-dev \
        libssh-gcrypt-dev \
        libxml2-dev \
        make \
        nmap \
        pkg-config \
        postgresql-server-dev-all \
        redis-server \
        rsync \
        sudo \
        uuid-dev \
        vim \
        xml-twig-tools \
        xmltoman \
        xsltproc

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        nodejs \
        yarn

WORKDIR /openvas
RUN for i in gvm-libs gvmd openvas gsa; do \
        git clone https://github.com/greenbone/$i --depth=1; \
        cd $i; \
        cmake .; \
        make install; \
        cd ..; \
        rm -rf $i; \
    done


RUN echo 'nobody ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/01-nobody && \
        chown -R nobody /openvas && \
        chown -R nobody /usr/local/var/
ADD redis.conf /etc/redis/redis.conf
USER nobody
RUN greenbone-nvt-sync
