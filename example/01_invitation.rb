require 'mackerel-client'
require 'dotenv'
require 'pp'
require 'time'

Dotenv.load
mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])
pp mc.get_organization()
pp mc.post_invitation(ENV['EMAIL'], "viewer")
#pp mc.revoke_invitation(ENV['EMAIL'])
pp user = mc.get_users()
pp mc.delete_user(user.id) unless user.any?
