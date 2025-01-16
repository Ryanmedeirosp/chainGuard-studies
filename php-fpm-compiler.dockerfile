FROM cgr.dev/chainguard/php:latest-fpm-dev AS build

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
    libtool \
    build-base \
    autoconf \
    automake \
    bison \
    re2c \
    libpng-dev \
    libjpeg-turbo-dev \
    libxpm-dev \
    libmcrypt-dev \
    libxml2-dev \
    curl-dev \
    mariadb-dev \
    bzip2-dev \
    git \
    php-dev \
    oniguruma-dev \
    libxslt-dev \
    # libzip-dev \
    # libssl-dev \
    # libcurl-dev \
    && rm -rf /var/cache/apk/*

# Recompilar oniguruma com -fPIC para garantir a compatibilidade
RUN cd /usr/include && \
    git clone https://github.com/kkos/oniguruma.git && \
    cd oniguruma && \
    ./autogen.sh && \
    ./configure CFLAGS="-fPIC" && \
    make && \
    make install

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
                 --with-pdo-mysql && \
    make -j$(nproc) && \
    make install

# Instalar a extensão mysqli
RUN cd php-src/ext/mysqli && \
    phpize && \
    ./configure && \
    make && \
    make install

# Adicionando a instalação dos módulos extras
RUN cd php-src/ext/mbstring && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN cd php-src/ext/soap && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN cd php-src/ext/xsl && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN cd php-src/ext/bcmath && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN cd php-src/ext/mysqli && \
    phpize && \
    ./configure && \
    make && \
    make install

RUN cd php-src/ext/pdo_mysql && \
    phpize && \
    ./configure && \
    make && \
    make install

# /build/php-src/ext/mysqli/modules
# /usr/lib/php/modules/mysqli.so

# Variáveis de ambiente para adicionar o PHP ao PATH
ENV PATH="/usr/local/bin:$PATH"

# Configuração do PHP-FPM para escutar em 0.0.0.0:9000
RUN sed -i -e "/^listen =/ s/^.*$/listen = 0.0.0.0:9000/" /usr/local/etc/php-fpm.d/www.conf.default

FROM cgr.dev/chainguard/php:latest-fpm-dev AS final

# Expor a porta 9000 para PHP-FPM
EXPOSE 9000

USER root

# Instalar pacotes adicionais com a flag --no-cache
RUN apk update --no-cache && apk add wget

# Criar o usuário www-data
RUN adduser -D -g 'www-data' www-data
RUN mkdir -p /usr/share/nginx/html

# Atribuir permissões
RUN chown -R www-data:www-data /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Copiar a configuração do PHP-FPM do estágio anterior
COPY --from=build /usr/lib/php/modules/mysqli.so /usr/lib/php/modules/mysqli.so
COPY --from=build /usr/lib/php/modules/soap.so /usr/lib/php/modules/soap.so
COPY --from=build /usr/lib/php/modules/xsl.so /usr/lib/php/modules/xsl.so
COPY --from=build /usr/lib/php/modules/bcmath.so /usr/lib/php/modules/bcmath.so
COPY --from=build /usr/lib/php/modules/mbstring.so /usr/lib/php/modules/mbstring.so
COPY --from=build /usr/lib/php/modules/pdo_mysql.so /usr/lib/php/modules/pdo_mysql.so

# Ativar os módulos no php.ini
RUN sed -i 's/^\s*;extension=mysqli/extension=mysqli/' /etc/php/php.ini
RUN sed -i 's/^\s*;extension=soap/extension=soap/' /etc/php/php.ini
RUN sed -i 's/^\s*;extension=xsl/extension=xsl/' /etc/php/php.ini
RUN sed -i 's/^\s*;extension=bcmath/extension=bcmath/' /etc/php/php.ini
RUN sed -i 's/^\s*;extension=mbstring/extension=mbstring/' /etc/php/php.ini
RUN sed -i 's/^\s*;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/php.ini

# Definir o comando que será executado no contêiner: PHP-FPM
CMD ["php-fpm8.3", "-F"]

# Docker Run Command (opcional, para referência)
# docker run -d --name php-fpm --network wordpress-net -v wordpress_data:/usr/share/nginx/html -p 9000:9000 php-fpm-compiler
