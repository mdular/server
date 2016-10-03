##
# Base setup
# manages basic packages, sets defaults
#
# @author Markus J Doetsch mdular.com
##

class role_base {

    # general packages
    package {["git", "curl", "ntp", "htop"]:
        ensure => latest
    }

    # purged packages
    package { "apache2":
        ensure => purged,
    }

    # default path for exec
    Exec {
        path      => '/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
    }

    # because we can
    file { '/etc/motd':
        content => hiera("motd")
    }
}
