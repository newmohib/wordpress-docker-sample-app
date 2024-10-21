<?php
// Custom wp-config.php for production

// ** MySQL settings ** //
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST')); // e.g., mysql.example.com:3306
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

// ** Authentication Unique Keys and Salts. ** //
define('AUTH_KEY',         'your unique phrase');
define('SECURE_AUTH_KEY',  'your unique phrase');
define('LOGGED_IN_KEY',    'your unique phrase');
define('NONCE_KEY',        'your unique phrase');
define('AUTH_SALT',        'your unique phrase');
define('SECURE_AUTH_SALT', 'your unique phrase');
define('LOGGED_IN_SALT',   'your unique phrase');
define('NONCE_SALT',       'your unique phrase');

// ** WordPress Database Table prefix. ** //
$table_prefix = 'wp_';

// ** For developers: WordPress debugging mode. ** //
define('WP_DEBUG', false);

// Add any additional configurations here

// That's all, stop editing! Happy blogging.
if ( !defined('ABSPATH') )
    define('ABSPATH', dirname(__FILE__) . '/');
require_once(ABSPATH . 'wp-settings.php');
