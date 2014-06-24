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
  }

  # php php-fpm component
  class { 'component_mdular_php': }
  # .sock configuration

  # nginx component
  class { 'component_mdular_nginx': }

  nginx::resource::vhost { 'www.puppetlabs.com':
    www_root => '/var/www/www.puppetlabs.com',
    ensure => absent
  }

  # mysql-server component
  class { 'component_mdular_mysql': }
}