# define host creation
#
# TODO: proper host configuration
# reverse proxy for node, fpm pools
# configuration for mdular.com on port 80
# serve static files properly
# gzip, mime-types (also for served fonts)
# routes *.php to php-fpm -> index.php
# error pages
# url rewrite
# .sock configuration
define web::nginx_host (
    $listen_options       = undef,
    $backend_port         = 9000,
    $php                  = true,
    $proxy                = undef,
    $www_root             = "/var/www/${name}/",
    $location_cfg_append  = undef,
    $htpasswd             = false,
    $server_name          = ["${name}"],
  ) {

  # create www root directory
  file { "/var/www/${name}":
    ensure => directory,
    require => File["/var/www"],
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  # htaccess
  # TODO: make this nice and use hiera users
  # TODO: create resource properly for each host
  if $htpasswd {
    file { "/etc/nginx/mdular_com.htpasswd":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('component_mdular_base/htpasswd/htpasswd.erb'),
      notify  => Service['nginx'],
    }

    $auth_basic = 'Restricted'
    $auth_basic_user_file = '/etc/nginx/mdular_com.htpasswd'
  } else {
    $auth_basic           = undef
    $auth_basic_user_file = undef
  }

  nginx::resource::vhost { "${name}":
    ensure              => present,
    server_name         => $server_name,
    listen_options      => $listen_options,
    www_root            => "${www_root}",
    rewrite_www_to_non_www  => true,
    #location_cfg_append => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
    gzip_types    => 'text/plain text/xml application/xml text/css application/x-javascript application/javascript',
    try_files     => ['$uri $uri/ /index.php?$args'],
    index_files   => ['index.html', 'index.php'],
    auth_basic    => $auth_basic,
    auth_basic_user_file => $auth_basic_user_file,
  }

  #if !$www_root {
  #  $tmp_www_root = undef
  #} else {
  #  $tmp_www_root = $www_root
  #}

  # ssl
  #nginx::resource::vhost { "${name}.${::domain} ${name}":
  #  ensure                => present,
  #  listen_port           => 443,
  #  www_root              => $tmp_www_root,
  #  proxy                 => $proxy,
  #  location_cfg_append   => $location_cfg_append,
  #  index_files           => [ 'index.php' ],
  #  ssl                   => true,
  #  ssl_cert              => 'puppet:///modules/sslkey/wildcard_mydomain.crt',
  #  ssl_key               => 'puppet:///modules/sslkey/wildcard_mydomain.key',
  #}

  nginx::resource::location { "${name}_htaccess":
    ensure  => present,
    vhost => "${name}",
    location  => "~ /\\.ht",
    location_deny => ['all'],
    location_custom_cfg => {}
  }

  if $php {
    nginx::resource::location { "${name}_root":
      ensure          => present,
      ssl             => false,
      #ssl_only        => true,
      #vhost           => "${name}.${::domain} ${name}",
      vhost           => "${name}",
      www_root        => "${www_root}",
      location        => '~ \.php$',
      index_files     => ['index.php'],
      proxy           => undef,
      #fastcgi         => "127.0.0.1:${backend_port}",
      fastcgi         => "unix:/var/run/php5-fpm.sock",
      fastcgi_script  => undef,
      location_cfg_append => $location_cfg_append
    }
  }
}

# initialize the nginx module
class component_mdular_nginx {

    class{'nginx':
      manage_repo => true,
      package_source => 'nginx-stable'
    }
  # TODO: global configuration from template
}
