RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#get_organizations' do

    let(:api_path) { "/api/v0/org" }
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

    let(:organization) { 
      {
        "name" => "HogeH",
        "displayName" => "Fuga",
      }
    }

    let(:response_object) {
      organization
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get organization" do
      expect(client.get_organization().to_h).to eq(organization)
    end
  end

end
