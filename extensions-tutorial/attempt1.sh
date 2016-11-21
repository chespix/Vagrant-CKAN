sudo chown vagrant:vagrant -R /usr/lib/ckan/default
. /usr/lib/ckan/default/bin/activate
cd /usr/lib/ckan/default/src
paster --plugin=ckan create -t ckanext ckanext-iauthfunctions
# skip --Creating a plugin class--
# skip --Adding the plugin to setup.py--
cd /usr/lib/ckan/default/src/ckanext-iauthfunctions
python setup.py develop
sudo cp /etc/ckan/default/production.ini /etc/ckan/default/development.ini
sudo sed -ibak 's/CKAN1/CKAN2/g;s/ckan.plugins = /ckan.plugins = iauthfunctions /g' /etc/ckan/default/development.ini
paster serve /etc/ckan/default/development.ini

# http://docs.ckan.org/en/ckan-2.6.0/extensions/tutorial.html#implementing-the-iauthfunctions-plugin-interface
