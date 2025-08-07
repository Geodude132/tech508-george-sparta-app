#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "Updating system..."
apt-get update -y && apt-get upgrade -y
echo

echo "Installing Nginx, Git, Curl..."
apt-get install nginx git curl -y
echo

echo "Configuring NGINX reverse proxy..."
sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://localhost:3000;|' /etc/nginx/sites-available/default
systemctl restart nginx
echo "NGINX configured and restarted."
echo

echo "Installing Node.js v20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs
echo "Node.js version: $(node -v)"
echo

echo "Installing PM2 globally..."
npm install -g pm2
echo

echo "Cloning your Sparta app repo..."
git clone https://github.com/Geodude132/tech508-george-sparta-app.git repo
cd repo/app
echo "Repo cloned and moved into app directory."
echo

export DB_HOST=mongodb://172.31.19.194:27017/posts
echo "Environment variable DB_HOST set."
echo

echo "Installing app dependencies..."
npm install
echo

echo "Deleting any existing PM2 process named sparta-app (if any)..."
pm2 delete all || true
echo

echo "Starting app with PM2 using npm start..."
pm2 start npm --name "app.js" -- start
echo "App started and registered with PM2."
echo

echo "Public IP address of this instance:"
curl -s http://checkip.amazonaws.com
echo

echo "App provisioning complete. "