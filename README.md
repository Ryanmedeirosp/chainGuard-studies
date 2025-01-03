# chainGuard-studies


# Imagens Personalizadas para WordPress com Nginx e PHP Baseadas no ChainGuard

Este repositório contém imagens Docker personalizadas para rodar o **WordPress** com **PHP-FPM**, **Nginx** e **MariaDB** de maneira segura, baseadas no **ChainGuard**. As imagens são projetadas para ambientes de produção, com ênfase na segurança e desempenho.

## Estrutura

- **Imagem Nginx**: Baseada na imagem `cgr.dev/chainguard/nginx`, otimizada para rodar o WordPress com o módulo `fastcgi` e configurações específicas.
- **Imagem PHP-FPM**: Baseada na imagem `cgr.dev/chainguard/php`, configurada para rodar o PHP-FPM com o WordPress.
- **MariaDB**: MariaDB não está incluído diretamente aqui, mas pode ser configurado e executado separadamente para suportar o banco de dados do WordPress.

## Como usar as imagens

### Pré-requisitos

1. **Docker** instalado no seu sistema.
2. **Rede Docker** configurada para permitir a comunicação entre os containers.

### Passos para executar

#### 1. **Construir as Imagens Personalizadas**

Antes de executar os containers, você precisa construir as imagens personalizadas para o Nginx e PHP-FPM.

Para construir as imagens, use os seguintes comandos na raiz do seu projeto:

```bash
# Para a imagem do Nginx
docker build -t custom-nginx .

# Para a imagem do PHP-FPM
docker build -t custom-php-fpm .
```

#### 2. **Executar os Containers**

Após construir as imagens, você pode executar os containers para o Nginx e PHP-FPM manualmente:

- **Rodar o Nginx:**

  O container do Nginx precisa estar configurado para servir o WordPress. Utilize o comando abaixo para rodá-lo:

  ```bash
  docker run -d --name nginx \
    --network wordpress-net \
    -v wordpress_data:/usr/share/nginx/html \
    -p 8080:8080 \
    custom-nginx
  ```

- **Rodar o PHP-FPM:**

  O container do PHP-FPM deve ser executado para processar as requisições PHP do WordPress:

  ```bash
  docker run -d --name php-fpm \
    --network wordpress-net \
    -v wordpress_data:/usr/share/nginx/html \
    -p 9000:9000 \
    custom-php-fpm
  ```

#### 3. **Configuração do Banco de Dados**

Embora a imagem do MariaDB não esteja incluída aqui, você pode usar qualquer imagem oficial do MariaDB ou outras imagens seguras para rodar o banco de dados necessário para o WordPress. Após configurar o banco de dados, edite o arquivo `wp-config.php` para garantir que o WordPress se conecte corretamente ao banco.

#### 4. **Acessar o WordPress**

Depois de iniciar os containers do Nginx e PHP-FPM, você pode acessar a instalação do WordPress no seu navegador, em `http://localhost:8080`. Complete o processo de instalação do WordPress conforme solicitado.

## Segurança e Melhores Práticas

- **Imagens Baseadas em ChainGuard**: As imagens de **PHP-FPM** e **Nginx** são baseadas em imagens seguras do ChainGuard, que foram auditadas e otimizadas para segurança.
- **Permissões**: As imagens garantem que os diretórios de aplicação estejam acessíveis apenas por usuários autorizados, minimizando riscos.
- **Atualizações Regulares**: As imagens são atualizadas frequentemente para corrigir vulnerabilidades e melhorar a segurança.

