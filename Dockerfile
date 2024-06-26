# Start with a PHP Alpine image with PHP 8.2 FPM
FROM php:8.2-fpm-alpine

# Install necessary packages and PHP extensions
RUN apk add --no-cache nginx wget \
    && apk add --no-cache \
    php82-pdo_mysql \
    php82-mysqli \
    php82-mbstring \
    php82-xml \
    php82-tokenizer \
    php82-fileinfo \
    php82-openssl \
    php82-json \
    php82-ctype \
    php82-curl \
    php82-dom \
    php82-session \
    php82-zip \
    php82-gd \
    php82-simplexml \
    && docker-php-ext-install mysqli pdo_mysql

# Create necessary directories
RUN mkdir -p /run/nginx /app

# Copy Nginx configuration
COPY docker/nginx.conf /etc/nginx/nginx.conf

# Copy application files
COPY src /app

# Copy startup script
COPY docker/startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh

# Set the working directory
WORKDIR /app

# Download and install Composer
RUN wget http://getcomposer.org/composer.phar \
    && chmod a+x composer.phar \
    && mv composer.phar /usr/local/bin/composer

# Install PHP dependencies
RUN COMPOSER_ALLOW_SUPERUSER=1 /usr/local/bin/composer install --no-dev

# Ensure the storage and bootstrap/cache directories are writable
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Expose the port
EXPOSE 80

# Run startup script
CMD ["/usr/local/bin/startup.sh"]
