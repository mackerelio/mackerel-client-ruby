require 'mackerel-client'
require 'dotenv'
require 'pp'
require 'time'

Dotenv.load
mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])

# Regist two hosts
pp mc.post_host({
  'name' => 'web001',
  'meta' => {
    'agent-name' => 'mackerel-agent/0.6.1',
    'agent-revision' => 'bc2f9f6',
    'agent-version'  => '0.6.1',
  },
  'type' => 'unknown',
  'status' => 'working',
  'memo' => 'test web host',
  'isRetired' => false,
  'createdAt' => '1401291970',
  'roleFullnames' => [
    'mackerel:web'
  ],
  'interfaces' => [{
      "ipAddress"   => "10.1.1.1",
      "macAddress"  => "08:00:27:ce:08:3d",
      "name"        => "eth0"
  }]
})
pp mc.post_host({
  'name' => 'db001',
  'meta' => {
    'agent-name' => 'mackerel-agent/0.6.1',
    'agent-revision' => 'bc2f9f6',
    'agent-version'  => '0.6.1',
  },
  'type' => 'unknown',
  'status' => 'working',
  'memo' => 'test db host',
  'isRetired' => false,
  'createdAt' => '1401291976',
  'roleFullnames' => [
    'mackerel:db'
  ],
  'interfaces' => [{
      "ipAddress"   => "10.0.0.1",
      "macAddress"  => "08:00:27:ce:08:3d",
      "name"        => "eth0"
  }]
})

# get information of host
pp hosts = mc.get_hosts
target_host = hosts.first
pp mc.get_host(target_host.id)
pp mc.get_host_metric_names(target_host.id)

# add host metadata 
namespace = "Scenario3"
pp mc.update_metadata(target_host.id, namespace, "metadata test")
pp metadata = mc.list_metadata(target_host.id)
pp mc.get_metadata(target_host.id, namespace)
pp mc.delete_metadata(target_host.id, namespace)

# Update the role and the status
pp mc.update_host_roles(target_host.id, [ "mackerel:web" ])
pp mc.update_host_status(target_host.id, 'poweroff')

# Update the host
pp mc.update_host(target_host.id,{
  'name' => 'db001',
  'meta' => {
    'agent-name' => 'mackerel-agent/0.6.1',
    'agent-revision' => 'bc2f9f6',
    'agent-version'  => '0.6.1',
  },
  'type' => 'unknown',
  'status' => 'working',
  'memo' => 'test host',
  'isRetired' => false,
  'createdAt' => '1401291976',
  'id' => target_host.id,
  'roleFullnames' => [
    'mackerel:db'
  ],
  'interfaces' => [{
      "ipAddress"   => "10.0.0.1",
      "macAddress"  => "08:00:27:ce:08:3d",
      "name"        => "eth0"
  }]
})

# retire the host
pp mc.retire_host(target_host.id)


