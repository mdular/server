# initialize the php module
class component_mdular_php {

  package { ["php5-cli", "php5-cgi"]:
    ensure => installed,
  } ->

  file { "/etc/php5/apache2": 
    ensure => directory,
  } ->

  class { 'php':
    service => 'nginx'
  }

  php::module { ["fpm"]: }
}
