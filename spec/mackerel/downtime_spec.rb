RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#create_downtime' do
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

    let(:api_path) { '/api/v0/downtimes' }
    let(:downtime_id) { 'abcxyz' }
    let(:name) { 'HogeHoge' }
    let(:start) { 1234567890 }
    let(:duration) { 10 }

    let(:response_object) {
      {
        'id' => downtime_id,
        'name' => name,
        'start' => start,
        'duration' => duration
      }
    }

    let(:downtime) {
      {
        'name' => name,
        'start' => start,
        'duration' => duration
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully create downtime" do
      expect(client.create_downtime(downtime).to_h).to eq(response_object)
    end
  end

  describe '#list_downtime' do
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

    let(:api_path) { '/api/v0/downtimes' }
    let(:downtime_id) { 'abcxyz' }
    let(:name) { 'HogeHoge' }
    let(:start) { 1234567890 }
    let(:duration) { 10 }

    let(:response_object) {
      {
        'downtimes' => [
          {
            'id' => downtime_id,
            'name' => name,
            'start' => start,
            'duration' => duration
          }
        ]
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully list downtime" do
      expect(client.list_downtime.to_h).to eq(response_object)
    end
  end

  describe '#update_downtime' do
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

    let(:api_path) { "/api/v0/downtimes/#{downtime_id}" }
    let(:downtime_id) { 'abcxyz' }
    let(:name) { 'HogeHoge' }
    let(:start) { 1234567890 }
    let(:duration) { 10 }

    let(:response_object) {
      {
        'id' => downtime_id,
        'name' => name,
        'start' => start,
        'duration' => duration
      }
    }

    let(:downtime) {
      {
        'name' => name,
        'start' => start,
        'duration' => duration
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully update downtime" do
      expect(client.update_downtime(downtime_id, downtime).to_h).to eq(response_object)
    end
  end

  describe '#delete_downtime' do
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
          stubs.delete(api_path) { stubbed_response }
        end
      end
    }

    let(:api_path) { "/api/v0/downtimes/#{downtime_id}" }
    let(:downtime_id) { 'abcxyz' }
    let(:name) { 'HogeHoge' }
    let(:start) { 1234567890 }
    let(:duration) { 10 }

    let(:response_object) {
      {
        'id' => downtime_id,
        'name' => name,
        'start' => start,
        'duration' => duration
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully delete downtime" do
      expect(client.delete_downtime(downtime_id).to_h).to eq(response_object)
    end
  end
end