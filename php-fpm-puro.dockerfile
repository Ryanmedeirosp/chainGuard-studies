FROM cgr.dev/chainguard/php:latest-fpm-dev 

# Expõe a porta 9000 para PHP-FPM
EXPOSE 9000
USER root 

# Criar o usuário www-data
RUN adduser -D -g 'www-data' www-data
RUN mkdir -p /usr/share/nginx/html
RUN  chown -R www-data:www-data /usr/share/nginx/html && \
chmod -R 755 /usr/share/nginx/html

# Definir o comando que será executado no contêiner: PHP-FPM
CMD ["php-fpm8.3", "-F"]

# Docker Run Command (opcional, para referência)
# docker run -d --name php-fpm --network wordpress-net -v wordpress_data:/usr/share/nginx/html -p 9000:9000 php-fpm
