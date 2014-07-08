# initialize the mysql module
class component_mdular_mysql {

  $mysqlConfig = hiera("mdular_base::mysql")

  class { '::mysql::server':
    root_password    => $mysqlConfig['rootPassword'],
    #override_options => { 'mysqld' => { 'max_connections' => '1024' } }
  }
}
