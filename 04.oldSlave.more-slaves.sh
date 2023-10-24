#!/bin/bash


read -p "your root user password: " PASS 

read -p "your new slave ip : " SLAVE_IP

# hotbackup from slave with slave info

xtrabackup --user=root --password=$PASS \
--backup --slave-info --target-dir=/tmp/more-slaves

xtrabackup --prepare --use-memory=2G --target-dir=/tmp/more-slaves

# send backupfile to new slave instance

rsync -avprP -e ssh /tmp/more-slaves root@$SLAVE_IP:/tmp 

rm -rf /tmp/more-slaves