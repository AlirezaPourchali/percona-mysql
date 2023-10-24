#!/bin/bash



read -p "your root user password: " PASS 

read -p "your slave ip : " SLAVE_IP

read -p "name of replication user? (repl1 , repl2 , repl3...): " REPL

read -p "password of the replication user:" REPL_PASS

# create new user for replication

mysql -e "CREATE USER '$REPL'@'$SLAVE_IP' IDENTIFIED BY '$REPL_PASS';" -p$PASS

mysql -e "GRANT REPLICATION SLAVE ON *.*  TO '$REPL'@'$SLAVE_IP'" -p$PASS
