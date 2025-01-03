# Stage 1: Builder (Instala o PHP e suas dependências)
FROM debian:12.8 AS builder

# Expõe a porta 9000 para PHP-FPM
EXPOSE 9000

# Atualiza o sistema e instala pacotes necessários
RUN apt update -y && \
    apt install -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    wget \
    curl \
    gnupg2 && \
    # Adiciona o repositório do PHP
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt update -y && \
    # Instala o PHP e suas extensões
    apt install -y \
    php8.3 \
    php8.3-fpm \
    php8.3-mysql \
    php8.3-curl \
    php-json \
    php8.3-xml \
    php8.3-mbstring && \
    # Limpa o cache do apt para reduzir o tamanho da imagem
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Modifica o arquivo de configuração do PHP-FPM para escutar em todas as interfaces
RUN sed -i -e "/^listen =/ s/^.*$/listen = 0.0.0.0:9000/" /etc/php/8.3/fpm/pool.d/www.conf && \
    # Opcional: Habilita short_open_tag se necessário
    sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php/8.3/fpm/php.ini

# Stage 2: Final (Cria a imagem PHP-FPM final)
FROM cgr.dev/chainguard/php:latest-fpm-dev AS final

# Expõe a porta 9000 para PHP-FPM
EXPOSE 9000

USER root 
# Instalar pacotes com a flag --no-cache
RUN apk update --no-cache && apk add wget

# Criar o usuário www-data
RUN adduser -D -g 'www-data' www-data
RUN mkdir -p /usr/share/nginx/html


RUN  chown -R www-data:www-data /usr/share/nginx/html && \
chmod -R 755 /usr/share/nginx/html
# Copia a configuração modificada do PHP-FPM do estágio anterior
COPY --from=builder /etc/php/8.3/fpm/pool.d/www.conf /etc/php/php-fpm.d/www.conf
COPY --from=builder /etc/php/8.3/fpm/php.ini /etc/php/8.3/fpm/php.ini

# Define o usuário para o contêiner (não é recomendado rodar como root no contêiner)


# Definir o comando que será executado no contêiner: PHP-FPM
CMD ["php-fpm8.3", "-F"]

# Docker Run Command (opcional, para referência)
# docker run -d --name php-fpm --network wordpress-net -v wordpress_data:/app -p 9000:9000 php-fpm
