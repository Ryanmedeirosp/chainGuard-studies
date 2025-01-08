FROM cgr.dev/chainguard/mariadb:latest-dev

EXPOSE 3306 

# Copiar o script SQL para o diretório de inicialização do MariaDB
COPY init.sql .



#  docker run -it --name mariadb -e MYSQL_ROOT_PASSWORD=1234 -e MYSQL_DATABASE=wordpress -e MYSQL_USER=user -e MYSQL_PASSWORD=1234 --network wordpress-net -p 3306:3306 mariadb:latest