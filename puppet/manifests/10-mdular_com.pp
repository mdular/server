# TOOD: create hosts automatically from hiera

class mdular_com (
    $users = {}, #hiera("mdular_com::users")
    $groups = {}, #hiera("mdular_com::groups")
    $mysql = {} #hiera("mdular_com::mysql")
  ) inherits role_webserver {

  
  # users, groups
  create_resources(user, $users)
  create_resources(group, $groups)

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
