#!/bin/bash

# install percona Server for MySQL
# interactie shell at the end to give your password

wget https://downloads.percona.com/downloads/Percona-Server-8.0/Percona-Server-8.0.31-23/binary/debian/buster/x86_64/Percona-Server-8.0.31-23-r71449379-buster-x86_64-bundle.tar
tar xvf Percona-Server-8.0.31-23-r71449379-buster-x86_64-bundle.tar
sudo dpkg -i *.deb

# install percona Xtrabackup 

wget https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.26-18/binary/debian/focal/x86_64/percona-xtrabackup-80_8.0.26-18-1.focal_amd64.deb
sudo dpkg -i percona-xtrabackup-80_8.0.26-18-1.focal_amd64.deb

sudo apt install zstd lz4 -y 

