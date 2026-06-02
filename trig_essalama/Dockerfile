FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git unzip curl libpq-dev libzip-dev zip

RUN docker-php-ext-install pdo pdo_mysql zip

WORKDIR /var/www/html

COPY . .

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80