FROM ubuntu:xenial

MAINTAINER Alexandre Mangin <amangin@irisit.fr>

ENV TERM xterm

RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
    apache2 iputils-ping curl dos2unix openssl supervisor\
    php php-cli libapache2-mod-php ca-certificates \
    php-gd php-json php-curl \
    php-ldap php-mbstring \
    php-mysql php-xml \
    php-xsl php-zip

RUN a2enmod rewrite && a2enmod headers

COPY files/apache/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY files/supervisor/* /etc/supervisor/conf.d/

VOLUME ["/var/www"]

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]