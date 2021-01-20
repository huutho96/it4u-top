#!/bin/bash
version=0.0.1

# build source code
cd source 
JEKYLL_ENV=production bundle exec jekyll build

# build docker image and push to docker hub
cd ../
docker build -t it4u-portal:$version .
docker tag it4u-portal:$version louisnguyen96/it4u-portal:$version
docker push louisnguyen96/it4u-portal:$version
