#!/bin/bash

echo provisioning

# PHP
sudo apt-get install --assume-yes php5-fpm
sudo apt-get install --assume-yes php5-cli
sudo apt-get install --assume-yes php5-common
sudo apt-get install --assume-yes php5-dev
sudo apt-get install --assume-yes php5-mcrypt
sudo apt-get install --assume-yes php5-mysql
sudo apt-get install --assume-yes php5-curl

gpg -q --keyserver keyserver.ubuntu.com --recv-key ABF5BD827BD9BF62
gpg -q -a --export ABF5BD827BD9BF62 | apt-key add -

# Other LAMP dependencies
sudo apt-get install --assume-yes nginx
sudo apt-get install --assume-yes mysql-server

# Utilities
sudo apt-get install --assume-yes git 
sudo apt-get install --assume-yes zip 
sudo apt-get install --assume-yes unzip 
sudo apt-get install --assume-yes vim
sudo apt-get install --assume-yes curl
sudo apt-get install --assume-yes dos2unix

# Node
sudo apt-get install --assume-yes g++
sudo apt-get install --assume-yes npm 
sudo apt-get install --assume-yes nodejs

if [ ! -f /usr/bin/node ]
then
  ln -s /usr/bin/nodejs /usr/bin/node
fi

# Download phpMyAdmin
if [[ ! -d /srv/database-admin ]]; then
    echo "Downloading phpMyAdmin 4.1.14..."
    cd /srv/
    wget -q -O phpmyadmin.tar.gz 'http://sourceforge.net/projects/phpmyadmin/files/phpMyAdmin/4.1.14/phpMyAdmin-4.1.14-all-languages.tar.gz/download'
    tar -xf phpmyadmin.tar.gz
    mv phpMyAdmin-4.1.14-all-languages database-admin
    rm phpmyadmin.tar.gz
fi

if [ ! -f /etc/nginx/sites-enabled/wordpress.conf ]
then
  ln -s /srv/config/nginx/wordpress.conf /etc/nginx/sites-enabled/wordpress.conf
fi

if [ ! -f /etc/nginx/sites-enabled/database-admin.conf ]
then
  ln -s /srv/config/nginx/database-admin.conf /etc/nginx/sites-enabled/database-admin.conf
fi

sudo service nginx restart

if [[ ! -f /srv/wordpress/wp-settings.php ]]; then
    cd /srv/wordpress
    wget -q http://wordpress.org/latest.zip -O /srv/wordpress/latest.zip
    unzip /srv/wordpress/latest.zip > /dev/null
    mv /srv/wordpress/wordpress/* /srv/wordpress/
    rmdir /srv/wordpress/wordpress
    rm /srv/wordpress/latest.zip
fi
