define sudoer () {

  file { "/etc/sudoers.d/${title}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0440',
    content => "${title} ALL=NOPASSWD:ALL",
  }
}

class component_mdular_base::sudoers (
    $sudoers = hiera("mdular_com::sudoers")
  ) {
  
  create_resources(sudoer, $sudoers)
}