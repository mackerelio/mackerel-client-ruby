require 'mackerel'
require 'mackerel/host'
require 'json'

describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#post_dashboard' do
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

    let(:id) { 'abcxyz' }
    let(:api_path) { '/api/v0/dashboards' }
    let(:title) { 'HogeHoge' }
    let(:bodyMarkdown) { '#HogeHoge' }
    let(:urlPath) { 'Hoge' }

    let(:dashboard) { 
      {
        'title' => title,
        'bodyMarkdown' => bodyMarkdown,
        'urlPath' => urlPath,
        'createdAt' => 1234567890,
        'updatedAt' => 1234567891
      }
    }

    let(:response_object) {
      dashboard
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post dashboard" do
      expect(client.post_dashboard(title, bodyMarkdown, urlPath).to_h).to eq(response_object)
    end
  end



  describe '#update_dashboard' do
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

    let(:id) { 'abcxyz' }
    let(:api_path) { "/api/v0/dashboards/#{id}" }
    let(:title) { 'HogeHoge' }
    let(:bodyMarkdown) { '#HogeHoge' }
    let(:urlPath) { 'Hoge' }

    let(:dashboard) { 
      {
				'id' => id,
        'title' => title,
        'bodyMarkdown' => bodyMarkdown,
        'urlPath' => urlPath,
        'createdAt' => 1234567890,
        'updatedAt' => 1234567891
      }
    }

    let(:response_object) {
      dashboard
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully update dashboard" do
      expect(client.update_dashboard(id, title, bodyMarkdown, urlPath).to_h).to eq(response_object)
    end
  end



  describe '#get_dashboards' do
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

    let(:id) { 'abcxyz' }
    let(:api_path) { "/api/v0/dashboards" }
    let(:title) { 'HogeHoge' }
    let(:bodyMarkdown) { '#HogeHoge' }
    let(:urlPath) { 'Hoge' }

    let(:dashboards) { 
      [
        {
  				'id' => id,
          'title' => title,
          'bodyMarkdown' => bodyMarkdown,
          'urlPath' => urlPath,
          'createdAt' => 1234567890,
          'updatedAt' => 1234567891
        }
      ]
    }

    let(:response_object) {
      { 'dashboards' => dashboards }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get dashboards" do
      expect(client.get_dashboards().map(&:to_h)).to eq(response_object['dashboards'])
    end
  end


  describe '#get_dashboard' do
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

    let(:id) { 'abcxyz' }
    let(:api_path) { "/api/v0/dashboards/#{id}" }
    let(:title) { 'HogeHoge' }
    let(:bodyMarkdown) { '#HogeHoge' }
    let(:urlPath) { 'Hoge' }

    let(:dashboard) { 
			{
				'id' => id,
				'title' => title,
				'bodyMarkdown' => bodyMarkdown,
				'urlPath' => urlPath,
				'createdAt' => 1234567890,
				'updatedAt' => 1234567891
			}
    }

    let(:response_object) {
      dashboard
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get dashboard" do
      expect(client.get_dashboard(id).to_h).to eq(response_object)
    end
  end


  describe '#delete_dashboard' do
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
          stubs.delete(api_path) { stubbed_response }
        end
      end
    }

    let(:id) { 'abcxyz' }
    let(:api_path) { "/api/v0/dashboards/#{id}" }
    let(:title) { 'HogeHoge' }
    let(:bodyMarkdown) { '#HogeHoge' }
    let(:urlPath) { 'Hoge' }

    let(:dashboard) { 
			{
				'id' => id,
				'title' => title,
				'bodyMarkdown' => bodyMarkdown,
				'urlPath' => urlPath,
				'createdAt' => 1234567890,
				'updatedAt' => 1234567891
			}
    }

    let(:response_object) {
      dashboard
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully delete dashboard" do
      expect(client.delete_dashboard(id).to_h).to eq(response_object)
    end
  end


end
