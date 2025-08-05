#!/bin/bash

# Update system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install dependencies
echo "Installing required packages..."
sudo apt install gnupg curl -y

# Add MongoDB GPG key
echo "Adding MongoDB GPG key..."
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
--dearmor --yes

# Add MongoDB repo (Ubuntu 22.04 codename is jammy)
echo "Adding MongoDB repository..."
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# Update packages again
echo "Updating package lists after adding MongoDB repo..."
sudo apt update

# Install MongoDB packages (specific versions)
echo "Installing MongoDB 7.0.22 and related tools..."
sudo apt install -y \
   mongodb-org=7.0.22 \
   mongodb-org-database=7.0.22 \
   mongodb-org-server=7.0.22 \
   mongodb-mongosh \
   mongodb-org-shell=7.0.22 \
   mongodb-org-mongos=7.0.22 \
   mongodb-org-tools=7.0.22 \
   mongodb-org-database-tools-extra=7.0.22

# Allow remote access by updating bindIp
echo "Configuring MongoDB to allow remote connections..."
sudo cp /etc/mongod.conf /etc/mongod.conf.bak
sudo sed -i '/^\s*bindIp:/s/127\.0\.0\.1/0.0.0.0/' /etc/mongod.conf

# Start and enable MongoDB service
echo "Starting and enabling MongoDB service..."
sudo systemctl start mongod
sudo systemctl enable mongod

echo "MongoDB installation and configuration complete."
