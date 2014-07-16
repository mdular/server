# initialize the php module
class component_mdular_php {

  # ensure dependencies for installation without apache
  package { ["php5-cli", "php5-cgi", "php-pear", "php5-fpm"]:
    ensure => installed,
  } ->

  # fix example42 php module trying to write apache2 php config
  file { "/etc/php5/apache2": 
    ensure => directory,
  } ->

  # initialize example42 php module
  class { 'php':
    service => 'php5-fpm',
    # version => '5.4.4-14+deb7u12', # TODO: make os detected variable
  }

  # declare php5-fpm service
  service { 'php5-fpm': 
    enable  => true,
    ensure  => running,
  }

  # additional php modules
  php::module { ["mysql"]: }

  php::module { ["apc"]:
    module_prefix => 'php-',
  }

  # install composer
  class { 'composer':
    #auto_update => true
  }
}
