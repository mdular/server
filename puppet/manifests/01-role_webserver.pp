class role_webserver inherits role_base {

  # firewall
  # rules
  firewall { '11 http':
    port    => [80],
    proto   => tcp,
    action  => accept
  }

  firewall { '12 https':
    port    => [443],
    proto   => tcp,
    action  => accept
  }

  file { "/var/www":
    ensure => directory,
    owner  => 'www-data',
    group  => 'www-data',
    mode   => '0755',
  }

  # nginx component
  class { 'component_mdular_nginx': }

  # php php-fpm component
  class { 'component_mdular_php': }

  # mysql-server component
  class { 'component_mdular_mysql': }
}
