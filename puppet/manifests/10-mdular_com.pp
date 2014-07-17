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

  # htaccess
  # TODO: make this nice and use hiera users
  # move into host creation by parameter / hiera flag
  #file { "/etc/nginx/mdular_com.htpasswd":
  #  owner   => 'root',
  #  group   => 'root',
  #  mode    => '0644',
  #  content => template('component_mdular_base/htpasswd/htpasswd.erb'),
    #notify  => Service[$serviceName],
  #}

  # create host
  web::nginx_host { 'mdular.com': 
    www_root => "/var/www/mdular.com/public"
    #backend_port => 9001,
  }

  # mysql db, user, grant
  create_resources(mysql_database, $mysql[databases])
  create_resources(mysql_user, $mysql[users])
  create_resources(mysql_grant, $mysql[grants])
}

# TODO: node declaration
class { 'mdular_com': }
