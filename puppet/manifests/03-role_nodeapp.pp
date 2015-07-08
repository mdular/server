class role_nodeapp inherits role_webserver {
  # TODO: role_webserver because of nginx..
  # consider creating role_proxy for firewall and nginx, since
  # mysql and php are not required for role_nodeapp

  # nodejs component
  #class { 'component_mdular_nodejs': }
}
