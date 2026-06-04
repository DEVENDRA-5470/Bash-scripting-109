#!/bin/bash

echo "This is nginx file last phase"

set -e

echo "Writing nginx file.."

PUBLIC_IP=$SERVER_IP

echo "Public IP found :$PUBLIC_IP"

sudo rm -f /etc/nginx/sites-enabled/default

sudo tee /etc/nginx/sites-available/lms > /dev/null << NGINX
server {
   listen 80;

   server_name $PUBLIC_IP;

   location / {
      proxy_pass http://127.0.0.1:5000;
      proxy_set_header Host \ $host;
      proxy_set_header X-Real-IP \ $remote_addr;
}
}
NGINX

sudo ln -sf /etc/nginx/sites-available/lms /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx > /dev/null 2>&1
echo "Nginx started"
