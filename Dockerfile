FROM php:8.1-fpm
LABEL maintainer="sinfallas@gmail.com"
LABEL build_date="2024-11-23"
WORKDIR /var/www
RUN mkdir -p /var/www/vendor
RUN apt-get update -qq && apt-get install -y build-essential libicu-dev libzip-dev libpng-dev libonig-dev libpq-dev zip unzip wget nano curl git && apt-get clean && rm -rf /var/lib/{apt,dpkg,cache,log} && apt -y autoremove
RUN docker-php-ext-install bcmath mbstring pcntl intl zip opcache gd pdo pdo_pgsql pgsql
RUN docker-php-ext-configure zip
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
COPY ./php.ini /usr/local/etc/php/php.ini
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN chmod 777 /usr/bin/composer
RUN groupadd -g 1000 www && useradd -u 1000 -ms /bin/bash -g www www
USER www
CMD ["php-fpm"]
