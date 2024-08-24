# Set the base image for subsequent instructions
FROM php:7.4-fpm as php
# Install PHP extensions and dependencies
RUN apt-get update \
    && apt-get install -y \
        libzip-dev \
        zlib1g-dev\
        unzip \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        sockets \
        zip
# Clear out the local repository of retrieved package files
RUN apt-get clean
RUN mkdir /app
ADD . /app
WORKDIR /app
# Install Composer
RUN curl --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install 
CMD php artisan serve --host=0.0.0.0 --port=8082
EXPOSE 8082