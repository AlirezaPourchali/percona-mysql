#!/bin/bash

# install percona Server for MySQL
# interactie shell at the end to give your password
cp /etc/resolve.conf /etc/resolve.conf.bak
echo "nameserver 178.22.122.100" > /etc/resolve.conf
curl -O https://repo.percona.com/apt/percona-release_latest.generic_all.deb
sudo apt install gnupg2 lsb-release ./percona-release_latest.generic_all.deb
sudo apt update
sudo percona-release setup ps80
sudo apt install percona-server-server -y 

# install percona Xtrabackup 
#wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
sudo apt install percona-xtrabackup-80 -y
#sudo dpkg -i percona-xtrabackup-80_8.0.26-18-1.focal_amd64.deb

sudo apt install zstd lz4 -y 

