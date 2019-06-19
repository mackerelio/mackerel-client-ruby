RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#get_users' do

    let(:api_path) { "/api/v0/users" }
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

    let(:users) { 
      {
        "users" => [
          {
            "id" => "XhHAo07",
            "screenName" => "WebServer",
            "email" => "hogehoge-exmaple@example.com"
          },
          {
             "id" => "YkLBo38",
             "screenName" => "DBServer",
             "email" => "fugafuga-exmaple@example.com"
          }
        ]
      }
    }

    let(:response_object) {
      users
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get users" do
      expect(client.get_users().map(&:to_h)).to eq(users['users'])
    end
  end

  describe '#remove_users' do

    let(:api_path) { "/api/v0/users/#{user_id}" }
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

    let(:user_id) { "XhHAo07" }
    let(:user) { 
      {
        "id" => user_id,
        "screenName" => "WebServer",
        "email" => "hogehoge-exmaple@example.com"
      }
    }

    let(:response_object) {
      user
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully delete users" do
      expect(client.remove_user(user_id).to_h).to eq(user)
    end
  end
 
end
