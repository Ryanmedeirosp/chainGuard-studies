FROM cgr.dev/chainguard/nginx:latest-dev

# EXPOSE 8080
USER root  
# Garantir permissões de root

# Instalar pacotes com a flag --no-cache
RUN apk update --no-cache && apk add wget
# RUN apk add --no-cache nginx-mod-fastcgi


# Criar o usuário www-data
RUN adduser -D -g 'www-data' www-data

COPY ./nginx /etc/nginx/conf.d/nginx.default.conf 
COPY ./nginx.conf /etc/nginx/nginx.conf


WORKDIR /usr/share/nginx/html  
# Cria automaticamente o diretório /usr/share/nginx/html

ADD https://wordpress.org/latest.tar.gz /usr/share/nginx/html
RUN tar -xvzf latest.tar.gz && \
    chown -R www-data:www-data /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

COPY ./wp-config.php /usr/share/nginx/html/wordpress/wp-config.php

# docker run -p 8080:8080 --network wordpress-net -v wordpress_data:/usr/share/nginx/html --name nginx nginx
