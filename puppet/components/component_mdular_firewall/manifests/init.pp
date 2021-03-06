# declare component
class component_mdular_firewall {

	# purge to ensure only rules managed by puppet
	resources {'firewall':
		purge => true
	}

	# run ::post and ::pre for resource
	Firewall{
		before	=> Class['component_mdular_firewall::post'],
		require => Class['component_mdular_firewall::pre']
	}

	# include firewall classes
	class { ['component_mdular_firewall::pre', 'component_mdular_firewall::post']: }
	class { 'firewall': }

	# add ssh rule
	firewall { '003 ssh':
		dport    => [22, 2222],
		proto    => tcp,
		action  => accept
	}
}
