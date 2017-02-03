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
        ruby \
        ruby-dev \
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

RUN gem install fpm

WORKDIR /openvas

RUN for i in openvas-libraries-8.0.8,2351 openvas-scanner-5.0.7,2367 openvas-manager-6.0.9,2359 greenbone-security-assistant-6.0.11,2363 openvas-cli-1.4.5,2397; do \
        IFS=","; \
        set -- $i; \
        wget http://wald.intevation.org/frs/download.php/$2/$1.tar.gz; \
        tar xfvz $1.tar.gz; \
        cd $1; \
        cmake .; \
        make install; \
        make DESTDIR=/tmp/openvas install; \
        cd ..; \
        rm -rf $1; \
        rm -rf $1.tar.gz; \
        done

RUN ldconfig
RUN fpm -s dir -t deb \
        --force \
        --name openvas \
        --depends "libglib2.0-0, libgpgme11, libksba8, libmicrohttpd10, libpcap0.8, libsnmp30, libssh-4, libldap-2.4-2, libxml2, libxslt1.1, libhiredis0.10, nsis, openssh-client, openssl, redis-server, rpm, rsync, sqlite3, wget" \
        --description "Openvas vulnerability scanner" \
        -C /tmp/openvas \
        --package /openvas

#ADD redis.conf /etc/redis/redis.conf
#ADD setup.sh setup.sh
#RUN chmod +x setup.sh
#ADD start.sh start.sh
#RUN chmod +x start.sh
#
#RUN ./setup.sh
#
#ENTRYPOINT ["/openvas/start.sh"]
