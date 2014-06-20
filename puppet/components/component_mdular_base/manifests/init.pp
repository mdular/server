class component_mdular_base {

	file { '/etc/motd':
    content => "banana\n"
  }

  # ssh user

  # user, groups

  # firewall
  class { 'component_mdular_firewall': }

  # git

  # htop

  # ntp
}
