FROM ubuntu:bionic
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
        graphviz \
        libical-dev \
        libldap2-dev \
        libgcrypt20-dev \
        libglib2.0-dev \
        libgnutls28-dev \
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
        xmltoman \
        xsltproc

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update > /dev/null \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        nodejs \
        yarn

RUN apt-get install -y xml-twig-tools

WORKDIR /openvas
RUN for i in gvm-libs gvmd gsa openvas; do \
        git clone https://github.com/greenbone/$i --depth=1; \
        cd $i; \
        sed -i 's/^.*GNUTLS_TLS1_3:.*$//g' /openvas/openvas/misc/network.c 2>&1 > /dev/null || true; \
        sed -i 's/^.*return OPENVAS_ENCAPS_TLSv13;.*$//g' /openvas/openvas/misc/network.c 2>&1 > /dev/null || true; \
        cmake .; \
        make install; \
        cd ..; \
        rm -rf $i; \
    done


#RUN git clone https://github.com/greenbone/gvm-libs
#WORKDIR /openvas/gvm-libs
#RUN cmake . && make install
#WORKDIR /openvas
#RUN git clone https://github.com/greenbone/gvmd
#WORKDIR /openvas/gvmd
#RUN cmake . && make install
#WORKDIR /openvas
#RUN git clone https://github.com/greenbone/gsa
#WORKDIR /openvas/gsa
#RUN cmake . && make install
#WORKDIR /openvas
#RUN git clone https://github.com/greenbone/openvas
#WORKDIR /openvas/openvas
## Hack to work around build errors when libgnutls does not support tls 1.3
#RUN sed -i 's/^.*GNUTLS_TLS1_3:.*$//g' /openvas/openvas/misc/network.c
#RUN sed -i 's/^.*return OPENVAS_ENCAPS_TLSv13;.*$//g' /openvas/openvas/misc/network.c
#RUN cmake .
#RUN make install
RUN echo 'nobody ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/01-nobody && \
        chown -R nobody /openvas && \
        chown -R nobody /usr/local/var/
ADD redis.conf /etc/redis/redis.conf
USER nobody
#RUN greenbone-nvt-sync
