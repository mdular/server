# TODO: create environments as resources from hiera

class dev_mdular_com (
    $users = {}, #hiera("mdular_com::users")
    $groups = {}, #hiera("mdular_com::groups")
    $mysql = {}, #hiera("mdular_com::mysql")
    $htpasswd = {} #hiera("mdular_com::htpasswd")
  ) inherits role_webserver {

  # users, groups
  create_resources(user, $users)
  create_resources(group, $groups)

  # create host
  web::nginx_host { 'dev.mdular.com':
    www_root => "/var/www/dev.mdular.com/public",
    server_name => ['dev.mdular.com'],
    htpasswd => true,
    #backend_port => 9001,
  }

  # mysql db, user, grant
  create_resources(mysql_database, $mysql[databases])
  create_resources(mysql_user, $mysql[users])
  create_resources(mysql_grant, $mysql[grants])
}

# include dev_mdular_com in puppet run
class { 'dev_mdular_com': }
