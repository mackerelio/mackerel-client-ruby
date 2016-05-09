require 'mackerel'
require 'mackerel/host'
require 'json'

describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe 'initialization' do
    it 'display an error message when api_key is absent' do
      expected_message = "API key is absent. Set your API key in a environment variable called MACKEREL_APIKEY."
      expect { Mackerel::Client.new() }.to raise_error(expected_message)
    end
  end

  describe '#post_host' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { '/api/v0/hosts' }

    let(:host) {
      {
        'name' => 'host001',
        'meta' => {},
      }
    }

    let(:response_object) {
      { 'id' => hostId }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post host" do
      expect(client.post_host(host)).to eq(response_object)
    end
  end

  describe '#get_host' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump({'host' => host.to_h})
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/hosts/#{hostId}" }

    let(:host) {
      Mackerel::Host.new(
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
        'id' => hostId,
        'createdAt' => '1401291976',
        'roles' => [
          'mackerel' => ['db']
        ],
        'interfaces' => [{
            "ipAddress"   => "10.0.0.1",
            "macAddress"  => "08:00:27:ce:08:3d",
            "name"        => "eth0"
        }],
      )
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully find host" do
      expect(client.get_host(hostId).to_h).to eq(host.to_h)
    end
  end

  describe '#update_host_status' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/hosts/#{hostId}/status" }

    let(:response_object) {
      { 'success' => true }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully update host status" do
      expect(client.update_host_status(hostId, :maintenance)).to eq(response_object)
    end
  end

  describe '#retire_host' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/hosts/#{hostId}/retire" }

    let(:response_object) {
      { 'success' => true }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully retire a host" do
      expect(client.retire_host(hostId)).to eq(response_object)
    end
  end

  describe '#post_metrics' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/tsdb" }

    let(:response_object) {
      { 'success' => true }
    }

    let(:metrics) { [
        { 'hostId' => hostId, 'name' => 'custom.metrics.loadavg', 'time' => 1401537844, 'value' => 1.4 },
        { 'hostId' => hostId, 'name' => 'custom.metrics.uptime',  'time' => 1401537844, 'value' => 500 },
    ] }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post metrics" do
      expect(client.post_metrics(metrics)).to eq(response_object)
    end
  end

  describe "#get_latest_metrics" do
    let(:stubbed_response) {
      [
       200,
       {},
       JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:metric_name) { "loadavg5" }

    let(:api_path) { "/api/v0/tsdb/latest" }

    let(:response_object) {
      {
        "tsdbLatest" => {
          hostId => {
            metric_name => {"time"=>1407898200, "value"=>0.03666666666666667},
          }
        }
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post metrics" do
      expect(client.get_latest_metrics([hostId], [metric_name])).to eq(response_object["tsdbLatest"])
    end
  end

  describe '#post_service_metrics' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:service_name) { 'service_name' }

    let(:api_path) { "/api/v0/services/#{service_name}/tsdb" }

    let(:response_object) {
      { 'success' => true }
    }

    let(:metrics) { [
        { 'name' => 'custom.metrics.latency', 'time' => 1401537844, 'value' => 0.5 },
        { 'name' => 'custom.metrics.uptime',  'time' => 1401537844, 'value' => 500 },
    ] }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post metrics" do
      expect(client.post_service_metrics(service_name, metrics)).to eq(response_object)
    end
  end

  describe '#define_graphs' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:api_path) { '/api/v0/graph-defs/create' }

    let(:response_object) {
      { 'success' => true }
    }

    let(:defs) { [
      {
        name: 'custom.fish-catch',
        displayName: 'My fish catch',
        unit: 'integer',
        metrics: [
          {
            name: 'custom.fish-catch.mackerel',
            displayName: 'Mackerel',
            isStacked: false,
          },
          {
            name: 'custom.fish-catch.herring',
            displayName: 'Herring',
            isStacked: false,
          },
          {
            name: 'custom.fish-catch.salmon',
            displayName: 'Salmon',
            isStacked: false,
          },
        ]
      }
    ] }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post metrics" do
      expect(client.define_graphs(defs)).to eq(response_object)
    end
  end

  describe '#get_hosts' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump({ 'hosts' => hosts.map(&:to_h) })
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/hosts.json" }

    let(:hosts) {
      [
        Mackerel::Host.new(
          'name' => 'mackereldb001',
          'meta' => {
            'agent-name' => 'mackerel-agent/0.6.1',
            'agent-revision' => 'bc2f9f6',
            'agent-version'  => '0.6.1',
          },
          'type' => 'unknown',
          'status' => 'working',
          'memo' => 'test host',
          'isRetired' => false,
          'id' => hostId,
          'createdAt' => '1401291976',
          'roles' => [
            'mackerel' => ['db']
          ],
          'interfaces' => [{
              "ipAddress"   => "10.0.0.1",
              "macAddress"  => "08:00:27:ce:08:3d",
              "name"        => "eth0"
          }],
        )
      ]
    }

    let(:opts) {
      { :service => 'mackerel', :roles => 'db' }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get hosts" do
      expect(client.get_hosts(opts).map(&:to_h)).to eq(hosts.map(&:to_h))
    end
  end
end
