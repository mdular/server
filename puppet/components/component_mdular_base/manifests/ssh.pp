define public_key ($key, $type) {

  $homepath = hiera("homepath")

  # ensure home directory
  file { "/${homepath}/${title}": 
    ensure  => directory,
    owner   => $title,
    group   => $title,
    mode    => '0750',
    require => [ User[$title], Group[$title] ],
  }

  # ensure .ssh directory
  file { "/${homepath}/${title}/.ssh": 
    ensure  => directory,
    owner   => $title,
    group   => $title,
    mode    => '0700',
    require =>  File["${homepath}/${title}"],
  }

  # add key
  ssh_authorized_key { $title:
    ensure          => present,
    name            => $title,
    user            => $title,
    type            => $type,
    key             => $key,
  }
}

class component_mdular_base::ssh (
    $serviceName = hiera("sshServicename"),
    $permitRootLogin = hiera("permitRootLogin"),
    $packages = hiera("sshPackages"),
    $publicKeys = hiera("publicKeys")
  ) {

  package { $packages:
    ensure  => present,
    before  => File["/etc/ssh/sshd_config"],
  }

  file { "/etc/ssh/sshd_config":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('component_mdular_base/ssh/sshd_config.erb'),
    notify  => Service[$serviceName],
  }

  service { $serviceName:
    ensure  => 'running',
    enable  => 'true',
  }

  create_resources(public_key, $publicKeys)
}
