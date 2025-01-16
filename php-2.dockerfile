FROM cgr.dev/chainguard/php:latest-fpm-dev AS final

# Expor a porta 9000 para PHP-FPM
EXPOSE 9000

USER root

# Instalar pacotes adicionais com a flag --no-cache
RUN apk update --no-cache && apk add wget

# Instalar pacotes de compilação necessários
RUN apk add --no-cache \
    php-8.3-mysqli \
    php-8.3-mysqli-config 

# Criar o usuário www-data
RUN adduser -D -g 'www-data' www-data
RUN mkdir -p /usr/share/nginx/html

# Atribuir permissões
RUN chown -R www-data:www-data /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

# Definir o comando que será executado no contêiner: PHP-FPM
CMD ["php-fpm8.3", "-F"]
