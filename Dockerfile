#FROM ubuntu:xenial
FROM ubuntu:trusty
MAINTAINER danielpops@gmail.com

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        alien \
        autoconf \
        bison \
        clang \
        cmake \
        curl \
        doxygen \
        flex \
        g++ \
        gcc \
        gcc-mingw-w64 \
        git \
        heimdal-dev \
        heimdal-multidev \
        libglib2.0-dev \
        libgnutls-dev \
        libgpgme11-dev \
        libhiredis-dev \
        libksba-dev \
        libldap2-dev \
        libmicrohttpd-dev \
        libpcap-dev \
        libpopt-dev \
        libsnmp-dev \
        libsqlite3-dev \
        libssh-dev \
        libxml2-dev \
        libxslt-dev \
        nsis \
        openssh-client \
        openssl \
        perl-base \
        pkg-config \
        python-lxml \
        python-pip \
        redis-server \
        rpm \
        rsync \
        sqlfairy \
        sqlite3 \
        tcl \
        texlive-latex-extra \
        uuid-dev \
        vim \
        wget \
        xmltoman \
        xsltproc \
    && apt-get clean


# Install nmap from source
# Openvas recommends an ancient version
ENV NMAP_VERSION=nmap-5.51
WORKDIR /nmap/
RUN curl -O https://nmap.org/dist/$NMAP_VERSION.tar.bz2 \
    && bzip2 -cd $NMAP_VERSION.tar.bz2 | tar xvf - \
    && cd /nmap/$NMAP_VERSION/ \
    && ./configure --prefix=/ \
    && make \
    && make install \
    && rm -rf /nmap/

WORKDIR /openvas

RUN for i in openvas-libraries-8.0.8,2351 openvas-scanner-5.0.7,2367 openvas-manager-6.0.9,2359 greenbone-security-assistant-6.0.11,2363 openvas-cli-1.4.5,2397; do \
        IFS=","; \
        set -- $i; \
        wget http://wald.intevation.org/frs/download.php/$2/$1.tar.gz; \
        tar xfvz $1.tar.gz; \
        cd $1; \
        cmake .; \
        make install; \
        cd ..; \
        rm -rf $1; \
        rm -rf $1.tar.gz; \
        done

RUN ldconfig

ADD redis.conf /etc/redis/redis.conf
ADD setup.sh setup.sh
RUN chmod +x setup.sh
ADD start.sh start.sh
RUN chmod +x start.sh

RUN ./setup.sh

ENTRYPOINT ["/openvas/start.sh"]
