class mdular_com (
    $users, #hiera("mdular_com::users")
    #$groups #hiera("mdular_com::groups")
  ) inherits role_webserver {

  
  # users, groups
  create_resources(user, $users)
  #create_resources(group, $groups)

  # create dirs, prepare deployment

  # host configuration
  # configuration for mdular.com on port 80
  # serves static files
  # routes *.php to php-fpm -> index.php
  # error pages
  # url rewrite

  # mysql db, user
}

# TODO: node declaration
class { 'mdular_com': }
