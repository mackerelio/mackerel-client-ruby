RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#post_monitoring_check_report' do
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

    let(:api_path) { '/api/v0/monitoring/checks/report' }
    let(:hostId) { '21obeF4PhZN' }

    let(:reports) {
      {
        reports: [
          {
            name: "check-report-test",
            status: "OK",
            message: "YOKERO!",
            occurredAt: Time.now.to_i.to_s,
            source: {
              type: "host",
              hostId: hostId
            }
          },
          {
            name: "check-report-test2",
            status: "OK",
            message: "OKOKOKOK!",
            occurredAt: Time.now.to_i.to_s,
            source: {
              type: "host",
              hostId: hostId
            }
          }
        ]
      }
    }

    let(:response_object) {
      {
        "success" => "true"
      }
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post monitoring checks report" do
      expect(client.post_monitoring_check_report(reports)).to eq(response_object)
    end
  end

end
