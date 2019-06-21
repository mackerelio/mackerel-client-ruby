RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

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
        builder.response :raise_error
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

  describe "#get_host_metrics" do
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
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:hostId) { '21obeF4PhZN' }

    let(:metric_name) { "loadavg5" }
    let(:from) { 1407898100 }
    let(:to) { 1407898300 }

    let(:api_path) { "/api/v0/hosts/#{hostId}/metrics" }

    let(:response_object) {
      {
        'metrics' => [
          {
            "time"=>1407898200,
            "value"=>0.03666666666666667
          }
        ]
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get host metrics" do
      expect(client.get_host_metrics(hostId, metric_name, from, to)).to eq(response_object["metrics"])
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
        builder.response :raise_error
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

    it "successfully get latest metrics" do
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
        builder.response :raise_error
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

    it "successfully post service metrics" do
      expect(client.post_service_metrics(service_name, metrics)).to eq(response_object)
    end
  end


  describe '#get_service_metrics' do
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
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:service_name) { "LAB" }
    let(:name) { 'custom.metrics.loadavg' }
    let(:from) { 1401537744 }
    let(:to) { 1401537944 }
    let(:api_path) { "/api/v0/services/#{service_name}/metrics" }
    let(:response_object) {
      { 'metrics' => metrics }
    }

    let(:metrics) { [
        { 'name' => 'custom.metrics.loadavg', 'time' => 1401537844, 'value' => 1.4 },
        { 'name' => 'custom.metrics.uptime',  'time' => 1401537844, 'value' => 500 },
    ] }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get service metrics" do
      expect(client.get_service_metrics(service_name, name, from, to)).to eq(metrics)
    end
  end


  describe "#define_graphs" do
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

    let(:graph_def){
      [
        {
          "name" => "custom.cpu.foo",
          "displayName" => "CPU",
          "unit" =>"percentage",
          "metrics" => [
            {
               "name" => "custom.cpu.foo.user",
               "displayName" => "CPU user",
               "isStacked" => true
            },
            { 
               "name" => "custom.cpu.foo.idle",
               "displayName" => "CPU idle",
               "isStacked" => true 
            }
          ]
        },
        {
          "name" => "custom.wild.#",
          "displayName" => "wildcard",
          "unit" => "float",
          "metrics" => [
            {
              "name" => "custom.wild.#.foo",
              "displayName" => "wild foo" 
            },
            {
              "name" => "custom.wild.#.bar",
              "displayName" => "wild bar"
            }
          ]
        }
      ]
    }
    let(:api_path) { "/api/v0/graph-defs/create" }

    let(:response_object) {
      { "success" => true }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post metrics" do
      expect(client.define_graphs(graph_def)).to eq({"success" => true})
    end
  end


end
