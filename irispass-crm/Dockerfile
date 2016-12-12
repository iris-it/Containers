FROM php:7.1.0-apache

MAINTAINER Alexandre Mangin <amangin@irisit.fr>

ENV APP_REPOSITORY="https://github.com/iris-it/iris-crm.git"

# Install all packages
RUN apt-get update -y && apt-get install -y git nodejs supervisor dos2unix
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN composer global require "hirak/prestissimo"

# Prepare config files
COPY build.sh /build.sh
COPY serve.sh /serve.sh

COPY files/services/* /etc/supervisord/
COPY files/conf/supervisor.conf /etc/supervisord.conf
COPY files/conf/apache.conf /etc/apache2/sites-available/000-default.conf

# Execute build
RUN dos2unix /build.sh
RUN chmod a+x /build.sh
RUN /build.sh

# Prepare Apache
RUN dos2unix /serve.sh
RUN chmod a+x /serve.sh
RUN /serve.sh

EXPOSE 80
VOLUME ["/var/www/app/storage"]

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]
CMD ["apache2-foreground"]


