#!/usr/bin/env bash

if [[ -f public/_index.php ]]; then
    mv -f public/index.php public/index.php.orig
    mv public/_index.php public/index.php
fi

if [ ! -d "vendor" ]; then
    composer install --prefer-dist --no-progress --no-interaction --no-ansi --no-dev --optimize-autoloader
fi

if [ ! -d "node_modules" ]; then
    npm install --legacy-peer-deps --production
    npm run build
fi

if [[ -f public/index.php.orig ]]; then
    rm -f public/index.php.orig
fi

if php artisan migrate:status >/dev/null 2>&1; then
    php artisan migrate --force
fi

# Кэширование конфигурации, маршрутов и представлений
php artisan migrate --force
php artisan route:clear
php artisan route:cache
php artisan cache:clear
php artisan config:clear
php artisan config:cache
php artisan view:clear
php artisan view:cache
