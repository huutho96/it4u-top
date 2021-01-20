#!/bin/bash
version=0.0.1

# update gem
bundle install

# build source code
JEKYLL_ENV=production bundle exec jekyll build --incremental

# build docker image and push to docker hub
docker build -t it4u-portal:$version .
docker tag it4u-portal:$version louisnguyen96/it4u-portal:$version
docker push louisnguyen96/it4u-portal:$version
