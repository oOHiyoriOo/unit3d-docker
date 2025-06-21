# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install base dependencies and add repositories
RUN apt-get update && \
    apt-get install -y software-properties-common curl && \
    add-apt-repository -y ppa:ondrej/php && \
    add-apt-repository -y ppa:linuxuprising/libpng12 && \
    apt-get update

# Install PHP, extensions, and other required tools
RUN apt-get install -y \
    git \
    unzip \
    nodejs \
    npm \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-curl \
    php8.2-gd \
    php8.2-zip \
    php8.2-bcmath \
    php8.2-intl \
    php-redis

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Copy and prepare the entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Install application dependencies
RUN composer install --no-dev --no-interaction --optimize-autoloader && \
    npm install && \
    npm run prod

# Set permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port for PHP-FPM
EXPOSE 9000

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Start PHP-FPM
CMD ["php-fpm"]