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

exec "$@"
