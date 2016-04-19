# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.hostname = "CKAN"

  config.vm.provider :virtualbox do |virtualbox|
    virtualbox.memory = '2048'
    virtualbox.cpus = '2'
  end

  config.vm.provision :shell, inline: <<-SHELL
    apt-get update
    apt-get install -y wget nginx apache2 libapache2-mod-wsgi libpq5
    if [ ! -f "/vagrant/python-ckan_2.5-trusty_amd64.deb" ]; then
      cd /vagrant
      wget http://packaging.ckan.org/python-ckan_2.5-trusty_amd64.deb
      cd
    fi
    dpkg -i /vagrant/python-ckan_2.5-trusty_amd64.deb
    a2enmod wsgi
    service apache2 restart
    apt-get install -y postgresql solr-jetty expect
    cp /vagrant/jetty /etc/default/jetty
    service jetty start
    mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
    ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
    ln -s /usr/bin/rotatelogs /usr/sbin/rotatelogs
    service jetty restart
    cp /vagrant/production.ini /etc/ckan/default/production.ini
    sudo -u postgres psql -c "CREATE USER ckan_default WITH PASSWORD 'Dh4rm4T3c';"
    sudo -u postgres psql -c "CREATE USER datastore_default WITH PASSWORD 'Dh4rm4T3c';"
    sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
    sudo -u postgres createdb -O ckan_default datastore_default -E utf-8
    ckan db init
    ckan datastore set-permissions | sudo -u postgres psql --set ON_ERROR_STOP=1
    mkdir -p /var/lib/ckan/default
    chown www-data /var/lib/ckan/default
    chmod u+rwx /var/lib/ckan/default
    service jetty restart
    service apache2 restart
    service nginx restart
    . /usr/lib/ckan/default/bin/activate
    cd /usr/lib/ckan/default/src/ckan
    expect -c 'spawn /usr/lib/ckan/default/bin/paster sysadmin add admin -c /etc/ckan/default/production.ini; expect -re ".*Create new user*"; sleep 3; send "y\r\n"; expect -re ".*Password*"; sleep 3; send "abc123\r\n";  expect -re ".*password*"; sleep 3; send "abc123\r\n"; expect -re "Added";'
  SHELL
end
