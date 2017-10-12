FROM tonyisworking/laravel-php7-nginx

MAINTAINER Dmitry Momot <mail@dmomot.com>

# install memcache extension
RUN apt-get update \
  && apt-get install -y libmemcached11 libmemcachedutil2 build-essential libmemcached-dev libz-dev \
  && pecl install memcached \
  && echo extension=memcached.so >> /usr/local/etc/php/conf.d/memcached.ini \
  && apt-get remove -y build-essential libmemcached-dev libz-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /tmp/pear

# Install mongodb, xdebug
RUN pecl install mongodb \
    && pecl install xdebug \
    && docker-php-ext-enable mongodb xdebug

# Install redis
RUN pecl install -o -f redis \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis
