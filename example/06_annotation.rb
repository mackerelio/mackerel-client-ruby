require 'mackerel-client'
require 'dotenv'
require 'pp'
require 'time'

Dotenv.load
mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])

current_time = Time.now.to_i
service = "website"
pp mc.post_annotation({
  title: "First Annotation",
  description: "Sinario Test Annotation",
  from: current_time - 6000,
  to: current_time - 60,
  service: service
})
pp annotation = mc.get_annotations(service, current_time - 6000, current_time).first
pp mc.update_annotation(annotation.id, {
  title: "Second Annotation",
  description: "Sinario Test Annotation",
  from: current_time - 6000,
  to: current_time - 60,
  service: service
})
pp mc.delete_annotation(annotation.id)
