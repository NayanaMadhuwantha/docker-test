FROM php:8.2-fpm-alpine

WORKDIR /var/www

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

RUN apk add --no-cache \
    git \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    bash

RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . /var/www

RUN composer install

#COPY --chown=www-data:www-data . /var/www
RUN chown -R appuser:appgroup /var/www

#USER www-data
USER appuser

EXPOSE 9000
CMD ["php-fpm"]
