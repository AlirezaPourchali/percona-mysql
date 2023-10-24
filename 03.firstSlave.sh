#!/bin/bash

read -p "your unique REPLICA server-id: " PERCONA_SERVER_ID 

read -p "REPLICA root password: " PASS 

read -p "MASTER ip: " MASTER_IP

read -p "replication user set: " REPL_USER

read -p "replication user password: " REPL_PASS 
# first we stop mysql and backup the main mysql data

sudo systemctl stop mysql

mv /var/lib/mysql /var/lib/mysql.bak

# then we restore data

xtrabackup --move-back --target-dir=/tmp/first-slave

chown -R mysql:mysql /var/lib/mysql

# now a unique server-id 

echo "server-id=$PERCONA_SERVER_ID" >> /etc/mysql/mysql.conf.d/mysqld.cnf

# start mysql

systemctl start mysql

# get binlog name and position

BINLOG_FILENAME=`cat /var/lib/mysql/xtrabackup_info | grep binlog_pos | cut -d "'" -f 2`
BINLOG_POS=`cat /var/lib/mysql/xtrabackup_info | grep binlog_pos | cut -d "'" -f 4` 

# enable GTID in slave

mysql -e "set @@global.ENFORCE_GTID_CONSISTENCY:=ON;" -p$PASS

mysql -e "set @@global.gtid_mode:=OFF_PERMISSIVE" -p$PASS

mysql -e "set @@global.gtid_mode:=ON_PERMISSIVE" -p$PASS

mysql -e "set @@global.gtid_mode:=ON" -p$PASS

# set replication source

mysql -e "CHANGE REPLICATION SOURCE TO
    SOURCE_HOST='$MASTER_IP',
    SOURCE_USER='$REPL_USER',
    SOURCE_PASSWORD='$REPL_PASS',
    SOURCE_LOG_FILE='$BINLOG_FILENAME',
    SOURCE_LOG_POS=$BINLOG_POS;
" -p$PASS

mysql -e "START REPLICA;" -p$PASS

mysql -e "SHOW REPLICA STATUS\G" -p$PASS

rm -rf /tmp/first-slave