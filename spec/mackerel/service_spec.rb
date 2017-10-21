require 'mackerel'
require 'mackerel/host'
require 'json'

describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#get_services' do

    let(:api_path) { "/api/v0/services" }
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

    let(:services) { 
      {
        "services" => [
          {
            "name" => "Web",
            "memo" => "store",
            "roles" => [
              "normal role",
              "special role"
            ]
          },
          {
             "name" => "Web",
             "memo" => "store",
             "roles" => [
               "a role",
               "the role"
             ]
          }
        ]
      }
    }

    let(:response_object) {
      services
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get services" do
      expect(client.get_services().map(&:to_h)).to eq(services['services'])
    end
  end


  describe '#get_roles' do

    let(:api_path) { "/api/v0/services/#{serviceName}/roles" }
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

    let(:serviceName) { "WebSite" }
    let(:roles) { 
      {
        "roles" => [
          {
            "name" => "Web",
            "memo" => "Apache2.2",
          },
          {
             "name" => "DB",
             "memo" => "Relational Database",
          }
        ]
      }
    }

    let(:response_object) {
      roles
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get services" do
      expect(client.get_roles(serviceName).map(&:to_h)).to eq(roles['roles'])
    end
  end


  describe '#get_service_metric_names' do

    let(:api_path) { "/api/v0/services/#{serviceName}/metric-names" }
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

    let(:serviceName) { "WebSite" }
    let(:metricNames) { 
      {
        "names" => [
            "CPU","Memory","Filesystem"
        ]
      }
    }

    let(:response_object) {
      metricNames
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get services" do
      expect(client.get_service_metric_names(serviceName)).to eq(metricNames['names'])
    end
  end

end
