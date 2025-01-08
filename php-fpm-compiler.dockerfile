FROM cgr.dev/chainguard/php:latest-fpm-dev

USER root

# Instalar pacotes de compilação necessários
RUN apk add --no-cache \
    build-base \
    autoconf \
    bison \
    re2c \
    libpng-dev \
    libjpeg-turbo-dev \
    libxml2-dev \
    curl-dev \
    mariadb-dev \
    git \
    && rm -rf /var/cache/apk/*

# Clonar o repositório PHP
RUN git clone https://github.com/php/php-src.git --branch=PHP-8.3

# Compilar o PHP
WORKDIR /php-src
RUN ./buildconf && \
    ./configure --with-mysqli --enable-fpm && \
    make -j$(nproc) && \
    make install

# Expor a porta para o PHP-FPM
EXPOSE 9000

# Definir o comando para rodar o PHP-FPM
CMD ["php-fpm8.3", "-F"]
