FROM debian:jessie

MAINTAINER Alexandre Mangin <amangin@irisit.fr>

ENV TERM linux
ENV DEBIAN_FRONTEND noninteractive


# PHP 7 | NodeJs 7
# Common
RUN echo "deb http://packages.dotdeb.org jessie all" > /etc/apt/sources.list.d/dotdeb.list && apt-get update && apt-get dist-upgrade -y --force-yes
RUN apt-get install -y --force-yes wget curl git dos2unix openssl ca-certificates supervisor apache2 iputils-ping nodejs build-essential sudo
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - && apt-get install -y --force-yes nodejs build-essential
RUN wget -O- https://www.dotdeb.org/dotdeb.gpg | apt-key add -

# PHP specific
RUN apt-get install -y --force-yes \
    php7.0 php7.0-cli libapache2-mod-php7.0 \
    php7.0-gd php7.0-json php7.0-curl \
    php7.0-ldap  php7.0-mbstring php7.0-mysql \
    php7.0-xml php7.0-xsl php7.0-zip

# Build Tools
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
RUN composer global require hirak/prestissimo
RUN npm install -g gulp yarn

# Apache
RUN a2enmod rewrite && a2enmod headers

# Config
COPY files/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY files/supervisor/* /etc/supervisor/conf.d/

# Build
WORKDIR /var/www

RUN rm -rf * && git clone https://github.com/iris-it/iris-crm.git .
RUN composer install --no-dev --prefer-dist && yarn && gulp --production
RUN chmod 775 -R storage && chmod 775 -R bootstrap && chown -R www-data:www-data .

VOLUME ["/var/www/storage/app"]

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]