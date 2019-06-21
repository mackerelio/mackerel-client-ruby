RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#get_channels' do

    let(:api_path) { "/api/v0/channels" }
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

    let(:channels) { 
      {
        "channels" => [
          { "id" => "361DhijkGFS" , "name" => "Default", "type" => "email" },
          { "id" => "361FijklHGT" , "name" => "alert_infomation", "type" => "slack" }
        ]
      }
    }

    let(:response_object) {
      channels
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get channels" do
      expect(client.get_channels().map(&:to_h)).to eq(channels['channels'])
    end
  end

end
