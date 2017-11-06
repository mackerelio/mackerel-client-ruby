require 'mackerel'
require 'mackerel/host'
require 'json'

describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#post_monitor' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object.to_h)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.post(api_path) { stubbed_response }
        end
      end
    }

    let(:api_path) { '/api/v0/monitors' }

    let(:monitor) {
      Mackerel::Monitor.new(
        'type' => 'host',
        'name' => 'monitor001',
        'duration' => 5,
        'metric' => 'loadavg5',
        'operator' => '>',
        'warning' => 4,
        'critical' => 6,
        'notificationInterval' => 600,
        'isMute' => false,
      )
    }

    let(:response_object) {
      Mackerel::Monitor.new(monitor.to_h.merge('id' => 'sgyzowm'))
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post monitor" do
      expect(client.post_monitor(monitor).to_h).to eq(response_object.to_h)
    end
  end

  describe '#get_monitors' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump({'monitors' => monitors})
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.get(api_path) { stubbed_response }
        end
      end
    }

    let(:api_path) { '/api/v0/monitors' }

    let(:monitors) {
      [
        {
          'id' => 'sgyzowm',
          'type' => 'host',
          'name' => 'monitor001',
          'duration' => 5,
          'metric' => 'loadavg5',
          'operator' => '>',
          'warning' => 4,
          'critical' => 6,
          'notificationInterval' => 600,
          'isMute' => false,
        },
        {
          'id' => 'Ux89M3G',
          'type' => 'service',
          'name' => 'monitor002',
          'service' => 'servicefoo',
          'duration' => 5,
          'metric' => 'foo.bar',
          'operator' => '>',
          'warning' => 40.0,
          'critical' => 60.0,
          'notificationInterval' => 600,
          'isMute' => false,
        },
        {
          'id' => '2mNFJaz3',
          'type' => 'external',
          'name' => 'monitor003',
          'url' => 'https://example.com',
          'maxCheckAttempts' => 3,
          'isMute' => false,
        }
      ]
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully find monitors" do
      expect(client.get_monitors().map{|monitor| monitor.to_h }).to eq(monitors)
    end
  end

  describe '#update_monitor' do
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
          stubs.put(api_path) { stubbed_response }
        end
      end
    }

    let(:monitorId) { 'sgyzowm' }

    let(:api_path) { "/api/v0/monitors/#{monitorId}" }

    let(:monitor) {
      {
        'type' => 'host',
        'name' => 'monitor001',
        'duration' => 5,
        'metric' => 'loadavg5',
        'operator' => '>',
        'warning' => 4,
        'critical' => 6,
        'notificationInterval' => 600,
        'isMute' => false,
      }
    }

    let(:response_object) {
      Mackerel::Monitor.new(monitor)
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully update a monitor" do
      expect(client.update_monitor(monitorId, monitor).to_h).to eq(monitor)
    end
  end

  describe '#delete_monitor' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object.to_h)
      ]
    }

    let(:test_client) {
      Faraday.new do |builder|
        builder.adapter :test do |stubs|
          stubs.delete(api_path) { stubbed_response }
        end
      end
    }

    let(:monitorId) { 'sgyzowm' }

    let(:api_path) { "/api/v0/monitors/#{monitorId}" }

    let(:monitor) {
      Mackerel::Monitor.new(
        'id' => monitorId,
        'type' => 'host',
        'name' => 'monitor001',
        'duration' => 5,
        'metric' => 'loadavg5',
        'operator' => '>',
        'warning' => 4,
        'critical' => 6,
        'notificationInterval' => 600,
        'isMute' => false,
      )
    }

    let(:response_object) {
      monitor
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully delete a monitor" do
      expect(client.delete_monitor(monitorId).to_h).to eq(response_object.to_h)
    end
  end

end
