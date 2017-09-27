#!/usr/bin/env ruby

require 'sinatra'
require 'mechanize'
require 'json'

set :environment, :production

config = JSON.parse(File.open("config.json").read())

discourse_api_key = config["discourse_api_key"]
coinhive_secret = config["coinhive_secret"]


before do
  @result = File.open("page.html")
end

agent = Mechanize.new()

def getBadgeIDs(username, agent)
    response = JSON.parse(agent.get("https://0x00sec.org/user-badges/" + username + ".json").body())
    response["badges"].map{|b| b["id"]}
end

set :port, 8080
ip = "0.0.0.0"
api_get = ""
data = []

Thread.new{
    loop {
        a = agent.get("https://api.coin-hive.com/user/list?secret="+coinhive_secret).body()
        data = JSON.parse(a)
        sorted = JSON.generate(data["users"].sort {|a,b| a["total"] <=> b["total"]}.reverse)
        api_get = sorted
        sleep 1
    }
}

Thread.new{
    loop {
		sleep 60

        puts "Doing check.."
		badge_mine_totals = {
			"bronze"=>1000000,
			"silver"=>5000000,
			"gold"=>10000000,
			"insane"=>100000000,
			"god"=>1000000000
		}

		badge_ids = {
			"bronze"=>117,
			"silver"=>118,
			"gold"=>119,
			"insane"=>120,
			"god"=>121
		}

		data["users"].each do |user|
			next if user["total"] < 1000000

			users_badges = getBadgeIDs(username, agent)

			badge_mine_totals.each do |badge_name, total|
				gets_badge? = user["total"] >= total

				current_badge_id = badge_ids[badge_name]

				# cleaner to skip up top than nest into another if.
				next if !gets_badge? || users_badges.include? current_badge_id

				# headers defaults to {} so no need to create.

				puts "Attempting to assign " + user["name"] + " " + badge_name + " badge."
				params = {
					"api_key"=> discourse_api_key,
					"api_username"=>"system",
					"username"=>user["name"],
					"badge_id"=>current_badge_id,
					"reason"=>"mined a lot of hashes"
				}

				agent.post("https://0x00sec.org/user_badges.json", params)
			end # badge_mine_totals.each
        end # data["users"].each
    }
}

get '/' do
    return @result
end

get '/data.json' do
	return api_get
end
