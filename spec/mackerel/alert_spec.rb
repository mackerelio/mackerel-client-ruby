RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#get_alerts' do
    let(:stubbed_response) {
      [
        200,
        {},
        JSON.dump(response_object)
      ]
    }

    let(:api_path) { '/api/v0/alerts' }

    let(:alertId) { 'abcdefg' }
    let(:monitorId) { 'hijklmnopqr' }
    let(:reason) { 'Nantonaku' }
    let(:alerts) {
      [
        {
          'id' => alertId,
          'status' => 'OK',
          'reason' => reason,
          'monitorId' => monitorId,
          'type' => 'check',
          'openedAt' => 1234567890
        }
      ]
    }

    let(:response_object) {
      { 'alerts' => alerts }
    }

    context 'no parameters' do
      let(:test_client) {
        Faraday.new do |builder|
          builder.response :raise_error
          builder.adapter :test do |stubs|
            stubs.get(api_path) { stubbed_response }
          end
        end
      }

      before do
        allow(client).to receive(:http_client).and_return(test_client)
      end

      it "successfully get alerts" do
        expect(client.get_alerts().map(&:to_h)).to eq(alerts)
      end
    end

    context 'with parameters' do
      let(:with_closed) { true }
      let(:next_id) { alertId }
      let(:limit) { 100 }

      let(:test_client) {
        Faraday.new do |builder|
          builder.response :raise_error
          builder.adapter :test do |stubs|
            stubs.get("#{api_path}?limit=#{limit}&nextId=#{next_id}&withClosed=#{with_closed}") { stubbed_response }
          end
        end
      }

      before do
        allow(client).to receive(:http_client).and_return(test_client)
      end

      it "successfully get alerts" do
        expect(
          client.get_alerts(with_closed: with_closed, next_id: next_id, limit: limit).map(&:to_h)
        ).to eq(alerts)
      end
    end
  end


  describe '#close_alert' do
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

    let(:alertId) { 'abcdefg' }
    let(:monitorId) { 'hijklmnopqr' }
    let(:reason) { 'Nantonaku' }
    let(:api_path) { "/api/v0/alerts/#{alertId}/close"}

    let(:alert) {
      {
        'id' => alertId,
        'status' => 'OK',
        'monitorId' => monitorId,
        'type' => 'check',
        'openedAt' => 1234567890
      }
    }

    let(:response_object) {
      Mackerel::Alert.new(alert)
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully close alert" do
      expect(client.close_alert(alertId, reason).to_h).to eq(alert)
    end
  end

end
