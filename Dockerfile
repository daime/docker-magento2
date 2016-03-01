FROM ubuntu:latest

# php ppa
RUN echo deb http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu trusty main >> \
    /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list

# dependencies
RUN apt-get -y update && \
    apt-get -y install --force-yes \
        curl \
        mysql-client \
        nginx \
        php5 \
        php5-cli \
        php5-curl \
        php5-fpm \
        php5-gd \
        php5-intl \
        php5-mcrypt \
        php5-mhash \
        php5-mysql \
        php5-xsl && \
        apt-get clean all

# composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# nginx
ADD etc/nginx.conf/fastcgi_params.conf /etc/nginx/conf/fastcgi_params.conf
ADD etc/nginx.conf/magento.conf /etc/nginx/conf/magento.conf
ADD etc/nginx.conf/default.conf /etc/nginx/conf.d/default.conf

# php
ADD etc/php.conf/php.ini /etc/php5/fpm/php.ini

# php fpm
ADD etc/php-fpm.conf/www.conf /etc/php5/fpm/pool.d/www.conf
RUN mkdir -p /var/lib/php/session /var/lib/php/wsdlcache && \
    chmod -R 777 /var/lib/php/session /var/lib/php/wsdlcache

ADD script /opt/script/
RUN chmod -R 777 /opt/script

ENTRYPOINT ["/bin/bash", "/opt/script/entrypoint.sh"]
