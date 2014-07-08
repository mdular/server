# initialize the php module
class component_mdular_php {

  # ensure dependencies for installation without apache
  package { ["php5-cli", "php5-cgi", "php-pear"]:
    ensure => installed,
  } ->

  # fix example42 php module trying to write apache2 php config
  file { "/etc/php5/apache2": 
    ensure => directory,
  } ->

  # initialize example42 php module
  class { 'php':
    service => 'nginx',
    #version => '5.4.4', # TODO: doesn't work?
  }

  # additional php modules
  php::module { ["fpm", "mysql"]: }

  # install composer
  class { 'composer':
    auto_update => true
  }
}
