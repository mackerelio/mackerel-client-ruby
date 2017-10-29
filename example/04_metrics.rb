require 'mackerel-client'
require 'dotenv'
require 'pp'
require 'time'

Dotenv.load
mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])

host = mc.get_hosts.first
current_time = Time.now.to_i
rand = Random.new(current_time.to_i)


pp mc.get_service_metric_names("website")


pp mc.get_host_metrics(host.id, "loadavg5", current_time - 6000, current_time)
pp mc.get_latest_metrics([host.id], ["loadavg5"])
pp mc.post_metrics([{
  hostId: host.id,
  name: "custom.host_metrics.example",
  time: current_time,
  value: rand.rand(20)
}])

pp mc.define_graphs([
  {
      "name" => "custom.define_graph",
      "displayName" => "defined_graph",
      "unit" => "percentage",
      "metrics" => [
         { "name" => "custom.define_graph.example", "displayName" => "Example", "isStacked" => false}
      ]
  }
])

pp mc.post_service_metrics("website", [{
  name: "custom.define_graph.example",
  time: current_time,
  value: rand.rand(20)
}])

pp mc.get_service_metrics("website", "custom.define_graph.example", current_time - 6000, current_time)

