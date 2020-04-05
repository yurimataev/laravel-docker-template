FROM alpine:3.11

# Set up environment variables
ENV DB_HOST=db
ENV DB_PORT=3306
ENV DB_DATABASE=laravel
ENV DB_USERNAME=laraveluser
ENV DB_PASSWORD=your_laravel_db_password

# Install packages
RUN apk --no-cache add php7 php7-fpm php7-pdo php7-pdo_mysql php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-xmlwriter php7-ctype \
    php7-session php7-mbstring php7-gd php7-fileinfo php7-tokenizer nginx supervisor curl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure nginx
COPY nginx-php/nginx.conf /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY nginx-php/php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY nginx-php/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisord
COPY nginx-php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup directories
RUN mkdir -p /var/www
RUN mkdir -p /run/nginx

# Copy the app into document root
# Irrelevant in the dev environment (because of mounted volume), necessary for production
WORKDIR /var/www
COPY app /var/www

# Install composer dependencies
RUN composer install

# Copy .env.example to .env
RUN cp /var/www/.env.example /var/www/.env

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]