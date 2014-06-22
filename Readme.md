# notes:
in default vm, run:
sudo apt-get update
sudo apt-get upgrade

# todo: add sources for dist upgrade
# run dist-upgrade
sudo apt-get dist-upgrade

# run puppet apply:

sudo puppet apply /vagrant/puppet/manifests/ --confdir=/vagrant/puppet
