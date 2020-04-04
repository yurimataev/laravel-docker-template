FROM alpine:3.11

# Install packages
RUN apk --no-cache add php7 php7-fpm php7-pdo php7-pdo_mysql php7-json php7-openssl php7-curl \
    php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader php7-ctype php7-session \
    php7-mbstring php7-gd nginx supervisor curl

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configure nginx
COPY nginx-php/nginx.conf /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY nginx-php/php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY nginx-php/php.ini /etc/php7/conf.d/custom.ini

# Configure supervisord
COPY nginx-php/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www
RUN mkdir -p /run/nginx

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Copy the app into document root
# Irrelevant in the dev environment, necessary for production
WORKDIR /var/www
COPY --chown=nobody app/ /var/www/

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]