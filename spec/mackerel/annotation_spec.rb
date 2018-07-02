RSpec.describe Mackerel::Client do
  let(:api_key) { 'xxxxxxxx' }
  let(:client) { Mackerel::Client.new(:mackerel_api_key => api_key) }

  describe '#post_graph_annotation' do
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

    let(:api_path) { '/api/v0/graph-annotations' }

    let(:annotationId) { 'bllotation' }
    let(:annotation) {
      {
        "title" => "deploy application",
        "description" => "link: https://example.com/",
        "from" => 1484000000,
        "to" => 1484000030,
        "service" => "ExampleService",
        "roles" => [ "ExampleRole1", "ExampleRole2" ]
      }
    }

    let(:response_object) {
      Mackerel::Annotation.new( annotation.merge({ 'id' => annotationId }) )
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully post annotation" do
      expect(client.post_graph_annotation(annotation).to_h).to eq( annotation.merge({ 'id' => annotationId }) )
    end
  end


  describe '#get_graph_annotations' do
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

    let(:api_path) { "/api/v0/graph-annotations"}

    let(:service) { "ExampleServic" }
    let(:from) { 1484020459 }
    let(:to) { 1484020759 }
    let(:annotations) {
      {
         "graphAnnotations" => [
            {
               "id" => "2UdH1QcZQaw",
               "title" => "Deploy application",
               "description" => "Deploy description",
               "from" => from,
               "to" => to,
               "service" => service
            },
            {
               "id" => "2UdH1QuiGgj",
               "title" => "Release application",
               "description" => "Release description",
               "from" => from,
               "to" => to,
               "service" => service,
               "roles" => [ "ExampleRole1", "ExampleRole2" ]
            }
         ]
       }
    }

    let(:response_object) {
      annotations
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully get annotations" do
      expect(client.get_graph_annotations(service, from, to).map(&:to_h)).to eq(annotations['graphAnnotations'])
    end
  end


  describe '#update_graph_annotation' do
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

    let(:api_path) { "/api/v0/graph-annotations/#{id}"}

    let(:id) { "abcdefg" }
    let(:service) { "ExampleServic" }
    let(:from) { 1484020459 }
    let(:to) { 1484020759 }
    let(:annotation) {
      {
         "title" => "Deploy application",
         "description" => "Deploy description",
         "from" => from,
         "to" => to,
         "service" => service
      }
    }

    let(:response_object) {
      annotation.merge({ "id" => id })
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully update annotation" do
      expect(client.update_graph_annotation(id, annotation).to_h ).to eq(annotation.merge({"id" => id}))
    end
  end


  describe '#delete_graph_annotation' do
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

    let(:api_path) { "/api/v0/graph-annotations/#{id}"}

    let(:id) { "abcdefg" }
    let(:service) { "ExampleServic" }
    let(:from) { 1484020459 }
    let(:to) { 1484020759 }
    let(:annotation) {
      {
         "title" => "Deploy application",
         "description" => "Deploy description",
         "from" => from,
         "to" => to,
         "service" => service
      }
    }

    let(:response_object) {
      annotation.merge({ "id" => id })
    }

    before do
      allow(client).to receive(:http_client).and_return(test_client)
    end

    it "successfully delete annotation" do
      expect(client.delete_graph_annotation(id).to_h ).to eq(annotation.merge({"id" => id}))
    end
  end


end
