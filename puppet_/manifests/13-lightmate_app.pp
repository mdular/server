# TODO: create environments as resources from hiera

class lightmate_app (
    $users = {}, #hiera("mdular_com::users")
    $groups = {}, #hiera("mdular_com::groups")
    $mysql = {}, #hiera("mdular_com::mysql")
    $htpasswd = {} #hiera("mdular_com::htpasswd")
  ) inherits role_nodeapp {

  # users, groups
  #create_resources(user, $users)
  #create_resources(group, $groups)

  # create host
  web::nginx_host { 'play.mdular.com':
    www_root => "/var/www/play.mdular.com",
    htpasswd => true,
    backend_port => 9001,
  }


}

# include lightmate_app in puppet run
#class { 'lightmate_app': }
