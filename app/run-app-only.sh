#cloud-boothook
#!/bin/bash

 export DB_HOST="mongodb://172.31.19.194:27017/posts"

# Navigate to app directory
cd /tech508-george-sparta-app/app

 npm install

# Stop existing PM2 processes
pm2 stop all || true

# Start app using PM2
pm2 start app.js 
