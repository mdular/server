##
# Application node
# installs nginx, redis, php5-fpm + modules & cphalcon & composer, postgresql
#
# @author Markus J Doetsch mdular.com
##

class role_appnode inherits role_base {
    package { ["nginx", "composer"]:
        ensure => latest
    }

    service { "nginx":
        ensure => running,
        require => Package['nginx'],
    }

    # disable default site
    file { "/etc/nginx/sites-enabled/default":
        ensure => absent,
        notify => Service["nginx"],
        require => Package["nginx"],
    }

    # package { ["redis-server", "redis-tools"]:
    #     ensure => latest
    # }
    #
    # service { "redis-server":
    #     ensure => running
    # }

    # PHP config
    $phpConfig = hiera_hash("php")

    # php5 cli and fpm deamon
    # php5-dev required to compile cphalcon
    package { ['php5-fpm', 'php5-cli', 'php5-dev']:
        ensure => latest,
    }

    service { "php5-fpm":
        ensure => running,
    }

    # php modules required by application
    package { ['php5-gd', 'php5-apcu', 'php5-intl', 'php5-mcrypt', 'php5-curl']:
        ensure => latest,
        require => Package["php5-fpm"],
        notify => Service["php5-fpm"],
    }

    # xdebug
    if $phpConfig['xdebug_enabled'] {
        $xdebugEnsure = 'latest'
    } else {
        $xdebugEnsure = 'absent'
    }
    package { 'php5-xdebug':
        ensure => $xdebugEnsure,
        require => Package["php5-fpm"],
        notify => Service["php5-fpm"],
    }

    # php settings
    file { ["/etc/php5/fpm/conf.d/90-mdular.ini", "/etc/php5/cli/conf.d/90-mdular.ini"]:
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("mdular_php/php.ini.erb"),
        notify  => Service['php5-fpm'],
        require => Package['php5-fpm'],
    }

    # yaml
    # exec { 'pecl install yaml':
    #     command => "echo | pecl install -f yaml",
    #     require => Package['php5-dev', 'libyaml-dev'],
    # #   onlyif => "pecl info yaml | grep -o 'Release Version' | xargs test -z $1",
    #     unless => "pecl info yaml",
    # } ->
    # file { '/etc/php5/mods-available/yaml.ini':
    #     ensure  => 'present',
    #     owner   => 'root',
    #     group   => 'root',
    #     mode    => '0644',
    #     content => 'extension=yaml.so',
    #     require => Package["php5-fpm"],
    # }
    # file { '/etc/php5/cli/conf.d/30-yaml.ini':
    #     ensure  => 'link',
    #     target  => '/etc/php5/mods-available/yaml.ini',
    #     require => File["/etc/php5/mods-available/yaml.ini"],
    #     notify  => Service['php5-fpm'],
    # }
    # file { '/etc/php5/fpm/conf.d/30-yaml.ini':
    #     ensure  => 'link',
    #     target  => '/etc/php5/mods-available/yaml.ini',
    #     require => File["/etc/php5/mods-available/yaml.ini"],
    #     notify  => Service['php5-fpm'],
    # }

    # phalcon
    # $phalconVersion = $phpConfig['phalcon_version']
    # if $phpConfig['phalcon_enabled'] {
    #     $phalconEnsure = 'link'
    # } else {
    #     $phalconEnsure = 'absent'
    # }

    # TODO: required for windows hosts?
	# exec { 'phalcon-dos2unix':
	# 	command => 'sudo dos2unix /tmp/install-phalcon.sh',
	# 	require => [
    #     	Package['dos2unix']
	# 	]
	# } ->

    # file { "/tmp/$phalconVersion":
    #     ensure => directory,
    #     mode => '0777'
    # }
    # exec { "git clone phalcon":
    #     cwd => "/tmp/$phalconVersion",
    #     command => "git clone --depth=1 --branch $phalconVersion https://github.com/phalcon/cphalcon.git .",
    #     require => [
    #         File["/tmp/$phalconVersion"],
    #         Package["git"],
    #     ],
    #     unless => "test -d .git",
    #     notify => Exec["install phalcon"]
    # }
    # TODO: version mechanics:
    #   when switching back to a previously installed version, the .so, link will still be wrong

    # TODO: update mechanics:
    #   check git fetch vs instealled HEAD version
    # exec { "git pull phalcon":
    #     cwd => "/tmp/n$phalconVersion",
    #     command => "git pull",
    #     require => File["/tmp/cphalcon$version"],
    #     unless => "grep $version .git/HEAD"
    # }

    # exec { "install phalcon":
    #     command => "./install",
    #     cwd => "/tmp/$phalconVersion/build",
    #     unless => "cmp ../.git/HEAD /var/phalcon-version",
    #     refreshonly => true,
    #     require => Package["php5-dev"],
    # }
    # file { "/var/phalcon-version":
    #     mode => '0777',
    #     source => "/tmp/$phalconVersion/.git/HEAD",
    #     require => Exec["install phalcon"],
    # }
    # file { "/etc/php5/mods-available/phalcon.ini":
    #     ensure  => 'present',
    #     owner   => 'root',
    #     group   => 'root',
    #     mode    => '0644',
    #     content => "extension=phalcon.so",
    #     require => [
    #         Package["php5-fpm"],
    #         Exec["install phalcon"],
    #     ],
    # }
    # file { "/etc/php5/cli/conf.d/80-phalcon.ini":
    #     ensure => $phalconEnsure,
    #     target => "/etc/php5/mods-available/phalcon.ini",
    #     require => File["/etc/php5/mods-available/phalcon.ini"],
    #     notify => Service["php5-fpm"],
    # }
    # file { "/etc/php5/fpm/conf.d/80-phalcon.ini":
    #     ensure => $phalconEnsure,
    #     target => "/etc/php5/mods-available/phalcon.ini",
    #     require => File["/etc/php5/mods-available/phalcon.ini"],
    #     notify => Service["php5-fpm"],
    # }

    # composer
    # exec { 'install composer':
    #     command => 'curl -sS https://getcomposer.org/installer | php -- --install-dir=/vagrant',
    #     creates => '/vagrant/composer.phar',
    #     environment => ["COMPOSER_HOME=/vagrant"],
    #     require => [
    #         Package['php5-cli'],
    #         Package['curl']
    #     ]
    # }

    # postgres
    # emits deprecations warnings, reported ticket:
    # https://tickets.puppetlabs.com/browse/MODULES-3328
    # class { 'postgresql::globals':
    #     manage_package_repo => true,
    #     version => '9.5',
    #     encoding => 'UTF-8',
    #     locale => 'en_US.UTF-8',
    # }
    #
    # class { 'postgresql::server':
    #     listen_addresses => '*',
    #     require => Class['postgresql::globals'],
    # }
    #
    # class { 'postgresql::server::contrib':
    #     package_ensure => 'latest',
    # }

    # TODO: mysql
    

    # elasticsearch
    # $esConfig = hiera_hash("elasticsearch")
    # $esVersion = $esConfig['version']
    # if $esConfig['enabled'] {
    #     $esEnsure = 'present'
    #     $esService = 'enabled'
    # } else {
    #     $esEnsure = 'absent'
    #     $esService = 'disabled'
    # }
    # class { 'elasticsearch':
    #     manage_repo => true,
    #     repo_version => $esVersion,
    #     package_pin => true,
    #     ensure => $esEnsure,
    #     status => $esService,
    #     require => Package['openjdk-7-jre-headless'],
    # }
    # # jre (required by elasticsearch)
    # package {"openjdk-7-jre-headless":
    #     ensure => $esEnsure,
    # }

    #todo: (e)lk (postponed)

    # statemachine graphs
    # todo: could be drawn clientside?
    # package { ['graphviz']:
    #     ensure => latest
    # }

    # create nginx host config
    # file { "/etc/hosts":
    #     ensure  => 'present',
    #     owner   => 'root',
    #     group   => 'root',
    #     mode    => '0644',
    #     content => template("mdular_nginx/hosts.erb"),
    # }

    #todo: image optimisation
    #"gifsicle", "jhead", "jpegoptim", "libjpeg-progs", "optipng", "pngcrush", "libpng-dev"

    # exec { "rm -rf /tmp/pngquant && mkdir /tmp/pngquant && cd /tmp/pngquant && wget -qO- https://github.com/pornel/pngquant/tarball/master | tar xvz --strip 1 && make && make install && rm -rf /tmp/pngquant":
    #   unless => "test -x /usr/local/bin/pngquant",
    #   require => Package['libpng-dev'],
    # }
    #
    # exec { "rm -rf /tmp/advancecomp && mkdir /tmp/advancecomp && cd /tmp/advancecomp && wget -qO- https://github.com/amadvance/advancecomp/releases/download/v1.20/advancecomp-1.20.tar.gz | tar xvz --strip 1 && ./configure && make && make install && rm -rf /tmp/advancecomp":
    #   unless => "test -x /usr/local/bin/advpng",
    #   require => Package['libpng-dev'],
    # }
}
