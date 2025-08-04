#!/bin/bash


# update and upgrade new window
sudo apt update && sudo apt upgrade -y

#install mongodb 
sudo apt-get install -y \
   mongodb-org=7.0.22 \
   mongodb-org-database=7.0.22 \
   mongodb-org-server=7.0.22 \
   mongodb-mongosh \
   mongodb-org-shell=7.0.22 \
   mongodb-org-mongos=7.0.22 \
   mongodb-org-tools=7.0.22 \
   mongodb-org-database-tools-extra=7.0.22
   
# cd into etc
cd ~/etc

# nano into mongod.conf
#sudo nano mongod.conf
use sed change bind IP to 0.0.0.0 in mongod.conf

#start mongod
sudo systemctl start mongod

#enable mongod
sudo systemctl enable mongod