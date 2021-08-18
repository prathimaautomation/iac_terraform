!#/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
cd /home/ubuntu/app
sudo npm install
sudo seeds/seed.js
sudo pm2 start