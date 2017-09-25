# CoinHive Leaderboard

### Quick Start

Change your values
```
cp config.json.example config.json
vim config.json
```

Generate a Gemfile.lock
```
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.1 bundle install
```

Build the image and run it
```
docker build -t pry0cc/leaderboard .
docker run -d -p 80:8080 --name leaderboard pry0cc/leaderboard
```

All done! If you need to setup CoinHive Monero Mining on Discourse, check out my other repos. I'll add my scripts soon.
