class role_base {

  class { 'component_mdular_base::packages': 
    installed_packages => [
      'curl',
      'git',
      'htop',
      'iotop',
    ],
    #purged_packages => [
      #'iotop'
    #]
  }

  # ntp

  # user, groups

  # ssh user

  # firewall
  class { 'component_mdular_firewall': }

  # git

  # htop
}
