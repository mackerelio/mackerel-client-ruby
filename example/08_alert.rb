require 'mackerel-client'
require 'dotenv'
require 'pp'
require 'time'

Dotenv.load
mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])
pp alert = mc.get_alerts().first
pp mc.close_alert(alert.id,"Sinario Test") unless alert.nil?

