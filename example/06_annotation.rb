require 'mackerel-client'
require 'dotenv'
require 'pp'
require 'time'

Dotenv.load
mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])

current_time = Time.now.to_i
service = "mackerel"
pp mc.post_graph_annotation({
  title: "First Annotation",
  description: "Scenario Test Annotation",
  from: current_time - 6000,
  to: current_time - 60,
  service: service
})
pp annotation = mc.get_graph_annotations(service, current_time - 6000, current_time).first
pp mc.update_graph_annotation(annotation.id, {
  title: "Second Annotation",
  description: "Scenario Test Annotation",
  from: current_time - 6000,
  to: current_time - 60,
  service: service
})
pp mc.delete_graph_annotation(annotation.id)
