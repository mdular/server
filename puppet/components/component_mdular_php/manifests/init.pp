# initialize the php module
class component_mdular_php {

  class { 'php':
    #version => '5.4.4',
    service => 'nginx',
  }
}
