FROM php:8.0.3-fpm

# install mysql driver
RUN docker-php-ext-install mysqli pdo pdo_mysql