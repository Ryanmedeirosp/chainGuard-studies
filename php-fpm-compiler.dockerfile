FROM cgr.dev/chainguard/php:latest-fpm-dev

USER root

# Remover pacotes relacionados ao PHP
RUN apk del --no-cache \
    php-8.3 \
    php-8.3-fpm \
    php-8.3-ctype \
    php-8.3-curl \
    php-8.3-iconv \
    php-8.3-mbstring \
    php-8.3-mysqlnd \
    php-8.3-openssl \
    php-8.3-pdo \
    php-8.3-pdo_mysql \
    php-8.3-pdo_sqlite \
    php-8.3-phar \
    php-8.3-sodium \
    && rm -rf /etc/php /usr/lib/php /usr/bin/php /var/log/php /var/cache/apk/* /usr/share/php

# Instalar pacotes de compilação necessários
RUN apk add --no-cache \
    build-base \
    autoconf \
    bison \
    re2c \
    libpng-dev \
    libjpeg-turbo-dev \
    libxpm-dev libmcrypt-dev \
    libxml2-dev \
    curl-dev \
    # mysql-dev \
    mariadb-dev \
    # libssl-dev libcurl-dev \
    git \
    php-dev \
    && rm -rf /var/cache/apk/*

WORKDIR /build

# Clonar o repositório PHP
RUN git clone https://github.com/php/php-src.git --branch=PHP-8.3.15 && \
    cd php-src && \
    ./buildconf && \
    ./configure  --with-mysqli=mysqlnd \
    --with-pdo-mysql=mysqlnd \
    --enable-mbstring \
    --enable-fpm \
    --enable-opcache \
    --enable-bcmath \
    --with-curl \
    --with-openssl \
    --with-zlib \
    --enable-mbregex \
    --enable-soap \
    --with-xsl \
    --with-bz2 \
    --enable-sockets \
    --with-kerberos \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-sysvmsg \
    --with-mysqli \
    --with-pdo-mysql \
    make -j$(nproc) && \
    make install INSTALL_ROOT=/usr/local

RUN cd php-src/ext/mysqli && \
phpize && \
./configure && \
make && \
make install  

# /build/php-src/ext/mysqli/modules
# /usr/lib/php/modules/mysqli.so

ENV PATH="/usr/local/bin:$PATH"

RUN  sed -i -e "/^listen =/ s/^.*$/listen = 0.0.0.0:9000/" /usr/local/etc/php-fpm.d/www.conf.default 
# RUN  sed -i "/^include/ s/NONE/\/usr\/local/" /usr/local/etc/php-fpm.conf.default   

WORKDIR /usr/share/nginx/html
# Expor a porta para o PHP-FPM
EXPOSE 9000

# Definir o comando para rodar o PHP-FPM
CMD ["php-fpm8.3","-F"]

# Docker Run Command (opcional, para referência)
# docker run -d --name php-fpm --network wordpress-net -v wordpress_data:/usr/share/nginx/html -p 9000:9000 php-fpm-compiler


