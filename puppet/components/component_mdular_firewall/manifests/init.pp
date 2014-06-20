# initialize the firewall module
resources {'firewall':
	purge => true
}
Firewall{
	before	=> Class['component_mdular_firewall::pre'],
	after 	=> Class['component_mdular_firewall::post']
}
class { ['component_mdular_firewall::pre', 'component_mdular_firewall::post']: }
class { 'firewall': }

# declare component
class component_mdular_firewall {
	package { 'iptables-persistent':
		ensure => latest,
	} ->

	firewall { '003 ssh':
		port    => [22, 2222],
		proto    => tcp,
		action  => accept
	}
}
