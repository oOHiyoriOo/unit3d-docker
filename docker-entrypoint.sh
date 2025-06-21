#!/bin/bash
set -e

# Generate app key if it doesn't exist
if [ -z "$APP_KEY" ]; then
    php artisan key:generate --force
fi

# Run database migrations
php artisan migrate --seed --force

# Execute the container's main command
exec "$@"
