require 'mackerel-client'
require 'dotenv'
require 'pp'
require 'time'

Dotenv.load
mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])
rand = Random.new(Time.now.to_i)
current_time = Time.now.to_i

host = mc.get_hosts.first
pp mc.post_monitoring_check_report({
  reports: [
    {
      name: "check-report-test",
      status: "OK",
      message: "YOKERO! NAPPA",
      occurredAt: current_time,
      source: {
        type: "host",
        hostId: host.id
      }
    }
  ]
})

pp mc.post_monitor({
  type: "host",
  name: "custom.define_graph.example",
  memo: "This is monitor test.",
  duration: 3,
  metric: "custom.define_graph.example",
  operator: ">",
  warning: 30.0,
  critical: 40.0,
  notificationInterval: 60
})
pp monitor = mc.get_monitors.first

pp mc.update_monitor(monitor.id , {
  type: "host",
  name: "custom.define_graph.example",
  memo: "This is monitor test.",
  duration: 1,
  metric: "custom.define_graph.example",
  operator: ">",
  warning: 5.0,
  critical: 10.0,
  notificationInterval: 60
})

mc.delete_monitor(monitor.id)

