# notes:
in default vm, run:
sudo apt-get update
sudo apt-get upgrade

# run dist-upgrade
sudo apt-get dist-upgrade

# run puppet apply:
sudo puppet apply /vagrant/puppet/manifests/ --confdir=/vagrant/puppet
sudo puppet apply /var/server/puppet/manifests/ --confdir=/var/server/puppet

# test hiera data 'mdular_com::users'
hiera -c /vagrant/puppet/hiera.yaml mdular_com::users settings::manifestdir=/vagrant/puppet/manifests

# update git submodules
git submodule foreach git checkout origin master
git submodule foreach git fetch origin master
git submodule foreach git pull origin master

git pull --recurse-submodules
git submodule update --recursive
