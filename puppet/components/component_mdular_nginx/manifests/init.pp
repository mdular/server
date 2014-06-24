# initialize the nginx module
class component_mdular_nginx {

  class { 'nginx': }
  # TODO: global configuration from template
}
