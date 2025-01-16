# chainGuard-studies

## Imagens Personalizadas para WordPress com Nginx e PHP Baseadas no ChainGuard

Este repositório fornece imagens Docker personalizadas para hospedar o **WordPress** utilizando **PHP-FPM**, **Nginx** e **MariaDB**, priorizando segurança e desempenho. As imagens são construídas com base em recursos seguros do **ChainGuard** e projetadas para ambientes de produção.

---

## Estrutura do Repositório

- **Imagem Nginx**:
  - Baseada em `cgr.dev/chainguard/nginx`.
  - Configurada para rodar o WordPress com suporte ao módulo `fastcgi`.
  - Inclui otimizações para desempenho e segurança.

- **Imagem PHP-FPM**:
  - Baseada em `cgr.dev/chainguard/php`.
  - Configurada para processar requisições PHP do WordPress.

- **Banco de Dados MariaDB**:
  - Embora não incluído diretamente neste repositório, você pode usar qualquer imagem oficial ou segura do MariaDB para gerenciar os dados do WordPress.

---

## Requisitos do Ambiente

Antes de iniciar, certifique-se de que possui:

1. **Docker** instalado.
2. **Rede Docker** configurada para comunicação entre os containers.
3. **Volumes Docker** para persistência de dados.

---

## Instruções de Uso

### 1. Construção das Imagens

Construa as imagens personalizadas para o Nginx e PHP-FPM executando os comandos abaixo na raiz do projeto:

```bash
# Construir a imagem Nginx
docker build -t custom-nginx -f nginx.dockerfile .

# Construir a imagem PHP-FPM
docker build -t custom-php-fpm -f php-fpm.dockerfile .
```

### 2. Configuração do Banco de Dados

Configure um container MariaDB separado para gerenciar o banco de dados do WordPress. Exemplo:

```bash
docker run -d --name mariadb \
  --network wordpress-net \
  -e MYSQL_ROOT_PASSWORD=yourpassword \
  -e MYSQL_DATABASE=wordpress \
  -e MYSQL_USER=wordpress \
  -e MYSQL_PASSWORD=wordpresspassword \
  mariadb:latest
```

### 3. Executando os Containers

#### Nginx:

Inicie o container do Nginx para servir o WordPress:

```bash
docker run -d --name nginx \
  --network wordpress-net \
  -v wordpress_data:/usr/share/nginx/html \
  -p 8080:80 \
  custom-nginx
```

#### PHP-FPM:

Inicie o container do PHP-FPM para processar requisições PHP:

```bash
docker run -d --name php-fpm \
  --network wordpress-net \
  -v wordpress_data:/usr/share/nginx/html \
  custom-php-fpm
```

### 4. Configuração do WordPress

1. Acesse o WordPress pelo navegador em `http://localhost:8080`.
2. Complete o assistente de configuração.
3. Certifique-se de configurar as credenciais do banco de dados no arquivo `wp-config.php`.

---

## Benefícios do Projeto

- **Segurança Aprimorada**: Utiliza imagens baseadas no ChainGuard, conhecidas por segurança auditada.
- **Flexibilidade**: Configuração modular para diferentes componentes do sistema.
- **Desempenho Otimizado**: Configurações ajustadas para uso eficiente de recursos em ambientes de produção.

---

## Melhores Práticas

- Mantenha as imagens e dependências sempre atualizadas.
- Utilize volumes para persistência de dados do WordPress.
- Restrinja permissões de acesso a arquivos sensíveis.
- Monitore os containers regularmente para evitar falhas ou ataques.

---

## Links úteis

- [Documentação do Docker](https://docs.docker.com)
- [Documentação do WordPress](https://wordpress.org/support/)
- [ChainGuard](https://chainguard.dev)



