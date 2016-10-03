##
# mdular.com environment
# setup nginx hosts, databases
#
# @author Markus J Doetsch mdular.com
##

# define postgres_db($user, $pass) {
#     postgresql::server::db { $title:
#         user     => $user,
#         password => postgresql_password($user, $pass),
#     }
#
#     postgresql::server::extension { "ltree$title":
#         extension => 'ltree',
#         database => $title,
#         ensure => present,
#     }
# }

define webroot () {
    file { "/var/www/${title}":
      ensure => directory,
      require => File["/var/www"],
      owner  => 'www-data',
      group  => 'www-data',
      mode   => '0755',
    }
}

define nginx_host ($hostname, $enabled) {

    # create nginx host config
    file { "/etc/nginx/sites-available/$hostname":
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template("mdular_nginx/nginx-host-$title.erb"),
        require => Package["nginx"],
    }

    if $enabled {
        $ensure = 'link'
    } else {
        $ensure = 'absent'
    }

    file { "/etc/nginx/sites-enabled/$hostname":
        ensure => $ensure,
        target => "/etc/nginx/sites-available/$hostname",
        notify => Service['nginx'],
        require => File["/etc/nginx/sites-available/$hostname"]
    }
}

# define elasticsearch_instance ($config) {
#     elasticsearch::instance { "$title":
#         config => $config,
#     }
# }

class mdular_com(
    $hosts = {},
    $databases = {},
    $search_instances = {},
    ) inherits role_appnode {

    # TODO: enable deep merging because hiera is kind of pointless without it

    # notify {"$databases":}

    # create_resources(webroot, $hosts)
    # create_resources(nginx_host, $hosts)
    # create_resources(postgres_db, $databases)
    # create_resources(elasticsearch_instance, $search_instances)

    # todo: initial composer install is too slow..
    # exec { "composer install":
    #     command => "php composer.phar install --no-progress --prefer-dist --no-interaction",
    #     cwd => "/vagrant",
    #     environment => ["COMPOSER_HOME=/tmp/composer"],
    #     unless => "test -d vendor",
    #     require => Exec['install composer'],
    #     notify => Exec['reset dev'],
    #     timeout => 600,
    #     user => 'vagrant',
    # }

    #todo: default fixtureset via hiera
    # exec { "reset dev":
    #     command => "bin/robo migrate:reset dev demo",
    #     cwd => "/vagrant",
    #     refreshonly => true,
    #     user => 'vagrant',
    # }
}

class { 'mdular_com': }
