class wakeandcamp_de (
    $users = {}, #hiera("mdular_com::users")
    $groups = {}, #hiera("mdular_com::groups")
    $mysql = {}, #hiera("mdular_com::mysql")
    $htpasswd = {} #hiera("mdular_com::htpasswd")
  ) inherits role_webserver {

  # create host
  web::nginx_host { 'wakeandcamp.de':
    www_root => "/var/www/wakeandcamp.de/public",
    server_name => ['wakeandcamp.mdular.com'],
  }

  # mysql db, user, grant
  create_resources(mysql_database, $mysql[databases])
  create_resources(mysql_user, $mysql[users])
  create_resources(mysql_grant, $mysql[grants])
}

# include in puppet run
class { 'wakeandcamp_de': }
