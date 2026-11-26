FROM php:8.6-fpm-alpine

# System libraries for PHP extensions
RUN apk add --no-cache \
        bash git unzip icu-libs libzip libpq libpng libjpeg-turbo libwebp freetype \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS icu-dev libzip-dev postgresql-dev libpng-dev libjpeg-turbo-dev libwebp-dev freetype-dev linux-headers \
    && docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype \
    && docker-php-ext-install -j"$(nproc)" pdo_pgsql pgsql intl bcmath zip pcntl opcache gd exif \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY docker/php/php.ini /usr/local/etc/php/conf.d/zz-app.ini
COPY docker/php/fpm-dev.conf /usr/local/etc/php-fpm.d/zz-dev.conf

WORKDIR /var/www/html

# -R: allow running workers as root (dev only, see fpm-dev.conf)
CMD ["php-fpm", "-R"]
