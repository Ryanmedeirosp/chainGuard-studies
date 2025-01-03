<?php
// ** Configurações do banco de dados MariaDB ** //
define('DB_NAME', 'wordpress');  // Nome do banco de dados
define('DB_USER', 'user');  // Usuário do banco de dados
define('DB_PASSWORD', '1234');  // Senha do banco de dados
define('DB_HOST', 'mariadb:3306');  // Host do banco de dados (nome do serviço no Docker)

define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// ** Chaves de segurança (você pode gerar outras se quiser) ** //
define('AUTH_KEY',         'chave gerada');
define('SECURE_AUTH_KEY',  'chave gerada');
define('LOGGED_IN_KEY',    'chave gerada');
define('NONCE_KEY',        'chave gerada');
define('AUTH_SALT',        'chave gerada');
define('SECURE_AUTH_SALT', 'chave gerada');
define('LOGGED_IN_SALT',   'chave gerada');
define('NONCE_SALT',       'chave gerada');

// Tabela do banco de dados do WordPress
$table_prefix = 'wp_';

// Ativar o debug (em produção, configure como false)
define('WP_DEBUG', false);

// Caminho absoluto do diretório do WordPress.
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');

// Configuração do WordPress
require_once(ABSPATH . 'wp-settings.php');
