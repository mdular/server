class habitat inherits role_base {
    # firewall
    # rules
    firewall { '20 habitat':
      dport    => [25565],
      proto   => tcp,
      action  => accept
    }
}
