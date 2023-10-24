#!/bin/bash

read -p "your root user password: " PASS 

read -p "your slave ip : " SLAVE_IP

read -p "name of replication user? (repl1 , repl2 , repl3...): " REPL

read -p "password of the replication user:" REPL_PASS

# enable GTID in master

mysql -e "set @@global.ENFORCE_GTID_CONSISTENCY:=ON;" -p$PASS

mysql -e "set @@global.gtid_mode:=OFF_PERMISSIVE" -p$PASS

mysql -e "set @@global.gtid_mode:=ON_PERMISSIVE" -p$PASS

mysql -e "set @@global.gtid_mode:=ON" -p$PASS

# hotbackup
xtrabackup --user=root --password=$PASS \
--backup --target-dir=/tmp/first-slave

xtrabackup --prepare --use-memory=2G --target-dir=/tmp/first-slave

# send backupfile to the slave instance

rsync -avprP -e ssh /tmp/first-slave root@$SLAVE_IP:/tmp

# create replication user

mysql -e "CREATE USER '$REPL'@'$SLAVE_IP' IDENTIFIED BY '$REPL_PASS';" -p$PASS

mysql -e "GRANT REPLICATION SLAVE ON *.*  TO '$REPL'@'$SLAVE_IP'" -p$PASS

rm -rf /tmp/first-slave