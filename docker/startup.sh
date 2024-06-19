#!/bin/sh

# Replace LISTEN_PORT with the environment variable PORT
sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf

# Start PHP-FPM
php-fpm -D

# Start Nginx
nginx
