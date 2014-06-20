class mdular_com inherits role_webserver {

  # create dirs, prepare deployment

  # host configuration
  # configuration for mdular.com on port 80
  # serves static files
  # routes *.php to php-fpm -> index.php
  # error pages
  # url rewrite

  # mysql db, user
}

# TODO: node declaration
class { 'mdular_com': }
