class component_mdular_base::packages(
    $installed_packages = [],
    $removed_packages = [],
    $purged_packages = []
  ) {

	package { $installed_packages:
		ensure => 'installed'
	}

	package { $removed_packages:
		ensure => 'absent'
	}

	package { $purged_packages:
		ensure => 'purged'
	}
}