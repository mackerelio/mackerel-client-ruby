require 'mackerel'
require 'mackerel/host'
require 'json'

describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#post_invitation' do

    let(:api_path) { "/api/v0/invitations" }
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

    let(:email) { "example@example.com" }
    let(:authority) { "viewer" }
    let(:invitation) {
      {
        "email" => email,
        "authority" => authority
      }
    }

    let(:response_object) {
      invitation
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post invitation" do
      expect(client.post_invitation(email, authority).to_h).to eq(response_object)
    end
  end



  describe '#revoke_invitation' do
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
    let(:email) { "example@example.com" }
    let(:api_path) { "/api/v0/invitations/revoke" }

    let(:invitation) { 
      {
        "email" => email,
        "authority" => "viewer",
      }
    }

    let(:response_object) {
      invitation.merge({ "expiresAt" => 1492393387 })
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully revoke invitation" do
      expect(client.revoke_invitation(email).to_h).to eq(invitation.merge({ "expiresAt" => 1492393387 }))
    end
  end

end
