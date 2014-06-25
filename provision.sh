#!/bin/bash

echo provisioning

sudo apt-get install --assume-yes g++
sudo apt-get install --assume-yes npm 
sudo apt-get install --assume-yes nodejs
sudo apt-get install --assume-yes git 
sudo apt-get install --assume-yes zip 
sudo apt-get install --assume-yes unzip 
sudo apt-get install --assume-yes vim
sudo apt-get install --assume-yes curl

if [ ! -f /usr/bin/node ]
then
  ln -s /usr/bin/nodejs /usr/bin/node
fi
