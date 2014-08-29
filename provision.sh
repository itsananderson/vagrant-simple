#!/bin/bash

echo provisioning

gpg -q --keyserver keyserver.ubuntu.com --recv-key ABF5BD827BD9BF62
gpg -q -a --export ABF5BD827BD9BF62 | apt-key add -

sudo apt-get update

# MySQL
#
# Use debconf-set-selections to specify the default password for the root MySQL
# account. This runs on every provision, even if MySQL has been installed. If
# MySQL is already installed, it will not affect anything.
echo mysql-server mysql-server/root_password password root | debconf-set-selections
echo mysql-server mysql-server/root_password_again password root | debconf-set-selections

# Other LAMP dependencies
sudo apt-get install --assume-yes nginx mysql-server
# PHP
sudo apt-get install --assume-yes php5-fpm php5-cli php5-common php5-dev php5-mcrypt php5-mysql php5-curl

# Utilities
sudo apt-get install --assume-yes git zip unzip vim curl dos2unix

# Node
sudo apt-get install --assume-yes g++ npm nodejs

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

if [ ! -f /etc/nginx/conf.d/php.conf ]
then
  ln -s /srv/config/nginx/php.conf /etc/nginx/conf.d/php.conf
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
