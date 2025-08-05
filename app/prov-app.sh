#!/bin/bash

# provision Sparta test app

echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y
echo "System updated."

# install required packages
echo "Installing nginx, git, curl..."
sudo apt install nginx git curl -y

# install Node.js 20 and npm
echo "Installing Node.js 20..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# verify Node version
node -v
npm -v

# install pm2 globally
echo "Installing pm2..."
sudo npm install -g pm2

echo "Cloning app repo..."
cd ~
if [ -d "tech508-george-sparta-app" ]; then
  echo "Repo already cloned, pulling latest changes..."
  cd tech508-george-sparta-app
  git pull
else
  git clone https://github.com/Geodude132/tech508-george-sparta-app.git
  cd tech508-george-sparta-app
fi

cd app

echo "Installing dependencies..."
npm install

# stop existing pm2 process if running
echo "Stopping any existing pm2 process..."
pm2 delete sparta-app || true

# start app using pm2 with environment variable
echo "Starting app with pm2 and DB_HOST environment variable..."
DB_HOST="mongodb://172.31.23.214:27017/posts" pm2 start app.js --name sparta-app

# save pm2 process list to resurrect on reboot (optional)
pm2 save

# --- NGINX REVERSE PROXY SETUP ---

echo "Backing up Nginx default config..."
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak

echo "Writing clean Nginx reverse proxy config..."
sudo tee /etc/nginx/sites-available/default > /dev/null << EOF
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

echo "Testing Nginx configuration..."
sudo nginx -t

echo "Restarting Nginx..."
sudo systemctl restart nginx

echo "Provisioning complete. The Sparta app should now be accessible without specifying port 3000."
