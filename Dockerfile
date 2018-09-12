FROM php:7.1-apache

ENV APACHE_DOCUMENT_ROOT /var/www/public

# set the required
ARG BLD_PKGS="libfreetype6-dev libjpeg62-turbo-dev libxml2-dev libmcrypt-dev libicu-dev unzip wget libz-dev libsasl2-dev libmagickwand-dev libmemcached-dev"
ARG PHP_EXTS="pdo_mysql gd intl mcrypt"
ARG PECL_EXT="uopz"

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN a2enmod rewrite & rm -rf /var/www/html \
    && chmod 775 -R /var/www/ \
    && chown -R www-data:www-data /var/www/ \
    && apt-get update \
    && apt-get -y install $BLD_PKGS \
        && pecl install $PECL_EXT && docker-php-ext-enable $PECL_EXT \
    && docker-php-ext-install $PHP_EXTS \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/