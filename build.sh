#!/bin/bash

docker build -t pry0cc/leaderboard .
docker run -d -p 80:8080 --name leaderboard pry0cc/leaderboard
