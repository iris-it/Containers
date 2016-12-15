FROM php:7.1.0-fpm-alpine

MAINTAINER Alexandre Mangin <amangin@irisit.fr>

# Install system packages
RUN apk add --update --no-cache nginx bash curl curl-dev git freetype libpng libmcrypt-dev libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libxml2-dev libxslt-dev

# Install php packages
RUN docker-php-ext-install curl
RUN docker-php-ext-install exif
RUN docker-php-ext-install fileinfo

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && docker-php-ext-install gd

RUN docker-php-ext-install json
RUN docker-php-ext-install opcache
RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install xml

# Clear contents of existing www directory
RUN rm -Rf /var/www/*

# Copy configuration files to root
COPY rootfs /

# Set working directory
WORKDIR /var/www

VOLUME ['/var/www']

# Expose the ports for nginx
EXPOSE 80
