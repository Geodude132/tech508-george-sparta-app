#!/bin/bash

# provision Sparta test app
echo "update..."
sudo apt-app update
echo "done"
echo

# FIX! ecpects user input
sudo apt-app upgrade -y
echo

# FIX! ecpects user input
sudo apt install nginx -y
echo

#configure reverse proxy using nginx

##install nodejs V20(installs as npm install)
sudo DEBIAN_FRONTEND=noninteractive bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -" && \
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
echo

#check node version
node -v
echo

#clone app code from repo
git clone https://github.com/Geodude132/tech508-george-sparta-app.git
#echo

#cd in to app folder 
cd {~\OneDrive\Documents\GitHub\tech508-george-sparta-app\app}
#echo

# set the enviroment variable
export DB_HOST=mongod://172.31.29.114:27017/posts


#npm install then npm start to start the app 
npm install && npm start &
echo

#check frontend
curl http://publicIP:3000
publicIP:3000
echo
