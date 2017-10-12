FROM tonyisworking/laravel-php7-nginx

MAINTAINER Dmitry Momot <mail@dmomot.com>

ENV TERM xterm

# install memcache extension
RUN
    apk add --update \
        autoconf \
        file \
        g++ \
        gcc \
        libc-dev \
        make \
        pkgconf \
        re2c \
        zlib-dev \
        libmemcached-dev && \
    cd /tmp && \
    wget https://github.com/php-memcached-dev/php-memcached/archive/php7.zip && \
    unzip php7.zip && \
    cd php-memcached-php7 && \
    phpize7 || return 1 && \
    ./configure --prefix=/usr --disable-memcached-sasl --with-php-config=php-config7 || return 1 && \
    make || return 1 && \
    make INSTALL_ROOT="" install || return 1 && \
    install -d "/etc/php7/conf.d" || return 1 && \
    echo "extension=memcached.so" > /etc/php7/conf.d/20_memcached.ini && \
    cd /tmp && rm -rf php-memcached-php7 && rm php7.zip

# Install mongodb, xdebug
RUN pecl install mongodb \
    && pecl install xdebug \
    && docker-php-ext-enable mongodb xdebug

# Install redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis
