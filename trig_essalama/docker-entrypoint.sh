#!/bin/bash
set -e

cd /var/www/html

if [ ! -f vendor/autoload.php ]; then
    echo "[entrypoint] vendor/autoload.php missing — running composer install..."
    composer install --no-interaction --prefer-dist --no-dev --optimize-autoloader --no-scripts
    composer dump-autoload --optimize
fi

if [ ! -f vendor/autoload.php ]; then
    echo "[entrypoint] FATAL: vendor/autoload.php still missing after composer install."
    exit 1
fi

# Render forwards traffic to $PORT (default 10000), not 80.
PORT="${PORT:-10000}"
export PORT

echo "[entrypoint] Configuring Apache on port ${PORT}..."

if [ -f /etc/apache2/ports.conf ]; then
    sed -i "s/^Listen 80$/Listen ${PORT}/" /etc/apache2/ports.conf
    sed -i "s/^Listen 80 /Listen ${PORT} /" /etc/apache2/ports.conf
fi

for conf in /etc/apache2/sites-available/*.conf /etc/apache2/sites-enabled/*.conf; do
    if [ -f "$conf" ]; then
        sed -i "s/<VirtualHost \*:80>/<VirtualHost *:${PORT}>/" "$conf"
    fi
done

echo "[entrypoint] Apache ready on 0.0.0.0:${PORT}"

exec "$@"
