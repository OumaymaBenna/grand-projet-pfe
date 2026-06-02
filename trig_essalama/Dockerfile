FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip curl libpq-dev libzip-dev zip

# PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip

# Apache rewrite
RUN a2enmod rewrite

# Fix Laravel public folder
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf

WORKDIR /var/www/html

# Copier TOUT le projet
COPY . .

# Installer Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 🔥 IMPORTANT : forcer installation propre SANS cache
RUN composer clear-cache
RUN composer install --no-interaction --prefer-dist --no-dev --optimize-autoloader

# Permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80