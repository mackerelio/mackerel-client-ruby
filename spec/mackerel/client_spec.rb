RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe 'initialization' do
    it 'display an error message when api_key is absent' do
      expected_message = "API key is absent."
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
        builder.response :raise_error
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


  describe '#update_host' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.put(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/hosts/#{hostId}" }

    let(:host) {
      {
        'name' => 'host001',
        'meta' => {"abcd" => "abcdefghijklmnopqlstu"}
      }
    }

    let(:response_object) {
      { 'id' => hostId }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully update host" do
      expect(client.update_host(hostId, host)).to eq(response_object)
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
        builder.response :raise_error
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
        'size' => 'standard',
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
        builder.response :raise_error
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


  describe '#update_host_roles' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.put(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/hosts/#{hostId}/role-fullnames" }

    let(:roles) {
        [
          'Web', 'Linux', 'NetworkG1'
        ]
    }

    let(:response_object) {
      { 'success' => true}
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully update host" do
      expect(client.update_host_roles(hostId, roles)).to eq({'success' => true})
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
        builder.response :raise_error
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
        builder.response :raise_error
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
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/hosts" }

    let(:hosts) {
      [
        Mackerel::Host.new(
          'name' => 'mackereldb001',
          'meta' => {
            'agent-name' => 'mackerel-agent/0.6.1',
            'agent-revision' => 'bc2f9f6',
            'agent-version'  => '0.6.1',
          },
          'size' => 'standard',
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

  describe '#post_graph_annotation' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:api_path) { '/api/v0/graph-annotations' }

    let(:response_object) {
      Mackerel::Annotation.new({
        'id' => 'XXX',
        'service' => 'myService',
        'roles' => ['role1', 'role2'],
        'from' => 123456,
        'to' => 123457,
        'title' => 'Some event',
        'description' => 'Something happend!'
      })
    }

    let(:annotation) {
      {
        'service' => 'myService',
        'roles' => ['role1', 'role2'],
        'from' => 123456,
        'to' => 123457,
        'title' => 'Some event',
        'description' => 'Something happend!'
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post graph annotations" do
      expect(client.post_graph_annotation(annotation).to_h).to eq(annotation.merge({ "id" => "XXX" }))
    end
  end

  describe '#list_metadata' do
    let(:stubbed_response) { [200, {}, JSON.dump(response_object)] }

    let(:test_client) {
      Faraday.new do |builder|
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:host_id) { '21obeF4PhZN' }

    let(:api_path) { "/api/v0/hosts/#{host_id}/metadata" }

    let(:response_object) {
      {
        'metadata' => [
          { 'namespace' => 'namespace1' },
          { 'namespace' => 'namespace2' }
        ]
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it 'successfully gets metadata namespaces' do
      expect(client.list_metadata(host_id)).to eq(response_object)
    end
  end

  describe '#get_metadata' do
    let(:stubbed_response) { [200, {}, JSON.dump(response_object)] }

    let(:test_client) {
      Faraday.new do |builder|
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:host_id) { '21obeF4PhZN' }

    let(:namespace) { 'namespace' }

    let(:api_path) { "/api/v0/hosts/#{host_id}/metadata/#{namespace}" }

    let(:response_object) {
      {
        'type' => 12345,
        'region' => 'jp',
        'env' => 'staging',
        'instance_type' => 'c4.xlarge'
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it 'successfully gets metadata' do
      expect(client.get_metadata(host_id, namespace)).to eq(response_object)
    end
  end

  describe '#update_metadata' do
    let(:stubbed_response) { [200, {}, JSON.dump(response_object)] }

    let(:test_client) {
      Faraday.new do |builder|
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.put(api_path) { stubbed_response }
        end
      end
    }

    let(:host_id) { '21obeF4PhZN' }

    let(:namespace) { 'namespace' }

    let(:api_path) { "/api/v0/hosts/#{host_id}/metadata/#{namespace}" }

    let(:response_object) {
      { 'success' => true }
    }

    let(:metadata) {
      {
        'type' => 12345,
        'region' => 'jp',
        'env' => 'staging',
        'instance_type' => 'c4.xlarge'
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it 'successfully updates metadata' do
      expect(client.update_metadata(host_id, namespace, metadata)).to eq(response_object)
    end
  end

  describe '#delete_metadata' do
    let(:stubbed_response) { [200, {}, JSON.dump(response_object)] }

    let(:test_client) {
      Faraday.new do |builder|
        builder.response :raise_error
        builder.adapter :test do |stubs|
          stubs.delete(api_path) { stubbed_response }
        end
      end
    }

    let(:host_id) { '21obeF4PhZN' }

    let(:namespace) { 'namespace' }

    let(:api_path) { "/api/v0/hosts/#{host_id}/metadata/#{namespace}" }

    let(:response_object) {
      { 'success' => true }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it 'successfully updates metadata' do
      expect(client.delete_metadata(host_id, namespace)).to eq(response_object)
    end
  end
end
