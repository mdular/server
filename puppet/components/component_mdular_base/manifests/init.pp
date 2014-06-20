class component_mdular_base {

	file { '/etc/motd':
    content => "banana\n"
  }

  # user, groups

  # ssh user

  # firewall
  class { 'component_mdular_firewall': }

  # git

  # htop

  # ntp
}
