#!/bin/bash

cd /home/clemence/appnode/etatdeslieux
git add .
today=$(date +"%Y-%m-%d")
git commit -m "Front Deployment on $today"
git push origin main

echo "Deploiement termine avec succes!"