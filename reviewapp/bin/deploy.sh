#!/bin/bash

# git commit and push changes  before deployment (with today date in message)
cd /home/juste/AppFlutter/etatdeslieux
git add .
today=$(date +"%Y-%m-%d")
git commit -m "Front Deployment before stripe remove on $today"
git push origin main


# app deployment
cd /home/juste/AppFlutter/etatdeslieux/reviewapp/
rm -rf ./build/
flutter build web --release 
ssh clemence@147.93.95.29 'rm -rf /home/clemence/appnode/etatdeslieux/api/web' 
scp -r /home/juste/AppFlutter/etatdeslieux/reviewapp/build/web clemence@147.93.95.29:/home/clemence/appnode/etatdeslieux/api

# admin deployment
cd /home/juste/AppFlutter/etatdeslieux/reviewadmin/
rm -rf ./build/
flutter build web --release 
ssh clemence@147.93.95.29 'rm -rf /home/clemence/appnode/etatdeslieux/api/webadmin' 
scp -r /home/juste/AppFlutter/etatdeslieux/reviewapp/build/web clemence@147.93.95.29:/home/clemence/appnode/etatdeslieux/api/webadmin






echo "Deploiement termine avec succes!"