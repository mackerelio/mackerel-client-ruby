require 'mackerel-client'
require 'dotenv'
require 'pp'
require 'time'

Dotenv.load
mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])

# make a dashboard
title = "Song of Anzu"
markdown = "
# Inform to labors

This is not a game or a concert.
Motivation is Nothing.
"
urlPath = "SongOfAnzu"
pp mc.post_dashboard(title, markdown, urlPath)

# Update the dashboard
new_title = "ThatSong"
pp dashboards = mc.get_dashboards
target_dashboard = dashboards.select{|d| d.urlPath =~ /#{urlPath}/ }.first
mc.get_dashboard(target_dashboard.id)
pp mc.update_dashboard(target_dashboard.id, new_title, markdown, urlPath)

# Delete the dashboard
pp mc.delete_dashboard(target_dashboard.id)

