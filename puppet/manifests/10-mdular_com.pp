class mdular_com (
    $users = {}, #hiera("mdular_com::users")
    $groups = {}, #hiera("mdular_com::groups")
    $mysql = {} #hiera("mdular_com::mysql")
  ) inherits role_webserver {

  
  # users, groups
  create_resources(user, $users)
  create_resources(group, $groups)

  # create dirs, prepare deployment
  file { "/var/www/mdular.com":
    ensure => directory,
    require => File["/var/www"],
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  # TODO: proper host configuration
  # configuration for mdular.com on port 80
  # serves static files properly
  # gzip, mime-types (also for served fonts)
  # routes *.php to php-fpm -> index.php
  # error pages
  # url rewrite
  # .sock configuration
  $full_web_path = "/var/www"

  define web::nginx_host (
      $backend_port         = 9000,
      $php                  = true,
      $proxy                = undef,
      $www_root             = "${full_web_path}/${name}/",
      $location_cfg_append  = undef,
    ) {
    nginx::resource::vhost { "${name}":
      ensure              => present,
      www_root            => "${www_root}",
      rewrite_www_to_non_www  => true,
      #location_cfg_append => { 'rewrite' => '^ https://$server_name$request_uri? permanent' },
      gzip_types    => 'text/plain text/xml application/xml text/css application/x-javascript application/javascript',
      try_files     => ['$uri $uri/ /index.php?$args'],
      index_files   => ['index.php'],
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
        location_cfg_append => {
          fastcgi_connect_timeout => '3m',
          fastcgi_read_timeout    => '3m',
          fastcgi_send_timeout    => '3m'
        }
      }
    }
  }

  web::nginx_host { 'mdular.com': 
    www_root => "${full_web_path}/mdular.com/public"
    #backend_port => 9001,
  }

  # mysql db, user, grant
  create_resources(mysql_database, $mysql[databases])
  create_resources(mysql_user, $mysql[users])
  create_resources(mysql_grant, $mysql[grants])
}

# TODO: node declaration
class { 'mdular_com': }
