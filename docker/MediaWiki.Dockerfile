FROM mediawiki:1.39.6

# install missing stuff and php extensions
RUN apt-get update && apt-get install -y \
      vim \
      unzip \
      libzip-dev \
      wget \
    && docker-php-ext-install zip

# install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer
    
# update mediawiki extensions via composer
COPY composer.local.json .
RUN composer self-update 2.1.3 && composer update --no-dev