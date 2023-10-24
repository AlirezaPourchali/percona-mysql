#!/bin/bash

# install percona Server for MySQL
# interactie shell at the end to give your password

sudo apt update

curl -O https://repo.percona.com/apt/percona-release_1.0-27.generic_all.deb

sudo apt install gnupg2 lsb-release ./percona-release_1.0-27.generic_all.deb -y

sudo apt update

sudo percona-release setup ps80

sudo apt install percona-server-server -y

# install percona Xtrabackup 

sudo apt install percona-xtrabackup-80 -y

sudo apt install zstd lz4 -y 

