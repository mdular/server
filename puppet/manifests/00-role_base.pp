class role_base {

  class { 'component_mdular_base': }

  class { 'component_mdular_base::packages': 
    installed_packages => [
      'curl',
      'git',
      'htop',
      'iotop',
    ],
    purged_packages => [
      'apache2.2-common'
    ]
  }
}
