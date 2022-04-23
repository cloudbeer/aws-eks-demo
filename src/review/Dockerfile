FROM php:8.0.3-fpm

# install mysql driver
RUN docker-php-ext-install mysqli pdo pdo_mysql

COPY ./ /app/
WORKDIR /app

# permision fix
RUN sed -ri 's/^www-data:x:82:82:/www-data:x:1000:50:/' /etc/passwd
RUN chown -R www-data:www-data /app
