class component_mdular_base (
    $users = {},
    $groups = {}
  ) {

	file { '/etc/motd':
    content => "banana\n"
  }

  # users, groups
  create_resources(user, $users)
  create_resources(group, $groups)

  # sudoers
  class { 'component_mdular_base::sudoers': }

  # ssh
  class { 'component_mdular_base::ssh': }

  # firewall
  class { 'component_mdular_firewall': }

  # git

  # htop

  # ntp
}
