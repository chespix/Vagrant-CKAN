# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "public_network"
  config.vm.hostname = "CKAN"

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.memory = '2048'
    virtualbox.cpus = '2'
  end

  config.vm.provision :shell, inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install -y wget nginx apache2 libapache2-mod-wsgi libpq5
    if [ ! -f "/vagrant/python-ckan_2.5-trusty_amd64.deb" ]; then
      cd /vagrant
      wget http://packaging.ckan.org/python-ckan_2.5-trusty_amd64.deb
      cd
    fi
    sudo dpkg -i /vagrant/python-ckan_2.5-trusty_amd64.deb
    sudo a2enmod wsgi
    sudo service apache2 restart
    sudo apt-get install -y postgresql solr-jetty
    sudo cp /vagrant/jetty /etc/default/jetty
    sudo service jetty start
    sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
    sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
    sudo ln -s /usr/bin/rotatelogs /usr/sbin/rotatelogs
    sudo service jetty restart
    sudo cp /vagrant/production.ini /etc/ckan/default/production.ini
    sudo -u postgres psql -c "CREATE USER ckan_default WITH PASSWORD 'Dh4rm4T3c';"
    sudo -u postgres psql -c "CREATE USER datastore_default WITH PASSWORD 'Dh4rm4T3c';"
    sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
    sudo -u postgres createdb -O ckan_default datastore_default -E utf-8
    sudo ckan db init
    sudo ckan datastore set-permissions | sudo -u postgres psql --set ON_ERROR_STOP=1
    sudo mkdir -p /var/lib/ckan/default
    sudo chown www-data /var/lib/ckan/default
    sudo chmod u+rwx /var/lib/ckan/default
    sudo service jetty restart
    sudo service apache2 restart
    sudo service nginx restart    
  SHELL
end
