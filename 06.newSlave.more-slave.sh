#!/bin/bash

read -p "your unique REPLICA server-id: " PERCONA_SERVER_ID 

read -p "REPLICA root password: " PASS 

read -p "MASTER ip: " MASTER_IP

read -p "replication user set: " REPL_USER

read -p "replication user password: " REPL_PASS 

# stop mysql then backup the main mysql data

sudo systemctl stop mysql

mv /var/lib/mysql /var/lib/mysql.bak

# then we restore data

xtrabackup --move-back --target-dir=/tmp/more-slaves

chown -R mysql:mysql /var/lib/mysql

# now a unique server-id 

echo "server-id=$PERCONA_SERVER_ID" >> /etc/mysql/mysql.conf.d/mysqld.cnf
echo "skip_replica_start" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# start mysql

systemctl start mysql

# get binlog name and position

BINLOG_FILENAME=`cat /var/lib/mysql/xtrabackup_slave_info |  cut -d "'" -f 2`
BINLOG_POS=`cat /var/lib/mysql/xtrabackup_slave_info |  cut -d "=" -f 3 | cut -d ";" -f 1` 

# enable GTID in slave

mysql -e "set @@global.ENFORCE_GTID_CONSISTENCY:=ON;" -p$PASS

mysql -e "set @@global.gtid_mode:=OFF_PERMISSIVE" -p$PASS

mysql -e "set @@global.gtid_mode:=ON_PERMISSIVE" -p$PASS

mysql -e "set @@global.gtid_mode:=ON" -p$PASS

# set replication source

mysql -e "CHANGE MASTER TO
     MASTER_HOST='$MASTER_IP',
     MASTER_USER='$REPL_USER',
     MASTER_PASSWORD='$REPL_PASS',
     MASTER_LOG_FILE='$BINLOG_FILENAME',
     MASTER_LOG_POS=$BINLOG_POS;
" -p$PASS


mysql -e "RESET REPLICA;" -p$PASS

mysql -e "START REPLICA;" -p$PASS

mysql -e "SHOW REPLICA STATUS\G" -p$PASS

rm -rf /tmp/first-slave