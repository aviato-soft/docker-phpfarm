#
# PHP Farm Docker image
#

# we use Debian as the host OS
FROM philcryer/min-wheezy:latest

MAINTAINER Andreas Gohr, andi@splitbrain.org

# the PHP versions to compile
ENV PHP_FARM_VERSIONS "5.2.17 5.3.29 5.4.44 5.5.32 5.6.18 7.0.3"

# add some build tools
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    apache2-mpm-prefork \
    build-essential \
    curl \
    git \
    libapache2-mod-fcgid \
    libbz2-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libltdl-dev \
    libmcrypt-dev \
    libmhash-dev \
    libmysqlclient-dev \
    libpng-dev \
    libsslcommon2-dev \
    libssl-dev \
    libt1-dev \
    libxml2-dev \
    libxpm-dev \
    pkg-config \
    wget

# reconfigure Apache
RUN rm -rf /var/www/*
COPY var-www /var/www/
COPY apache  /etc/apache2/

# install the phpfarm script
RUN git clone https://github.com/cweiske/phpfarm.git phpfarm

# add customized configuration
COPY phpfarm /phpfarm/src/

# compile, then delete sources (saves space)
RUN cd /phpfarm/src && ./docker.sh

# set path
ENV PATH /phpfarm/inst/bin/:/usr/sbin:/usr/bin:/sbin:/bin

# expose the ports
EXPOSE 8052 8053 8054 8055 8056 8070

# run it
WORKDIR /var/www
COPY run.sh /run.sh
CMD ["/bin/bash", "/run.sh"]
