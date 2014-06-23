# notes:
in default vm, run:
sudo apt-get update
sudo apt-get upgrade

# todo: add sources for dist upgrade
# run dist-upgrade
sudo apt-get dist-upgrade

# run puppet apply:
sudo puppet apply /vagrant/puppet/manifests/ --confdir=/vagrant/puppet

# test hiera data 'mdular_com::users'
hiera -c /vagrant/puppet/hiera.yaml mdular_com::users settings::manifestdir=/vagrant/puppet/manifests