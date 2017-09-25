#!/bin/bash

docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.1 bundle install
docker build -t pry0cc/leaderboard .
docker run -d -p 80:8080 --name leaderboard pry0cc/leaderboard
