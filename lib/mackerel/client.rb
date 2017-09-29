require 'faraday'
require 'uri'

require 'json' unless defined? ::JSON
require 'mackerel/host'

module Mackerel

  class Client

    ERROR_MESSAGE_FOR_API_KEY_ABSENCE = "API key is absent. Set your API key in a environment variable called MACKEREL_APIKEY."

    def initialize(args = {})
      @origin       = args[:mackerel_origin]  || 'https://mackerel.io'
      @api_key      = args[:mackerel_api_key] || raise(ERROR_MESSAGE_FOR_API_KEY_ABSENCE)
      @timeout      = args[:timeout]          || 30 # Ref: apiRequestTimeout at mackerel-agent
      @open_timeout = args[:open_timeout]     || 30 # Ref: apiRequestTimeout at mackerel-agent
    end

    def post_host(host)
      response = client.post "/api/v0/hosts" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = host.to_json
      end

      unless response.success?
        raise "POST /api/v0/hosts failed: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def get_host(host_id)
      response = client.get "/api/v0/hosts/#{host_id}" do |req|
        req.headers['X-Api-Key'] = @api_key
      end

      unless response.success?
        raise "GET /api/v0/hosts/#{host_id} failed: #{response.status}"
      end

      data = JSON.parse(response.body)
      Host.new(data['host'])
    end

    def update_host_status(host_id, status)
      unless [:standby, :working, :maintenance, :poweroff].include?(status.to_sym)
        raise "no such status: #{status}"
      end

      response = client.post "/api/v0/hosts/#{host_id}/status" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = { "status" => status }.to_json
      end

      unless response.success?
        raise "POST /api/v0/hosts/#{host_id}/status failed: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def retire_host(host_id)
      response = client.post "/api/v0/hosts/#{host_id}/retire" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = { }.to_json
      end

      unless response.success?
        raise "POST /api/v0/hosts/#{host_id}/retire failed: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def post_metrics(metrics)
      response = client.post '/api/v0/tsdb' do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = metrics.to_json
      end

      unless response.success?
        raise "POST /api/v0/tsdb failed: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def get_latest_metrics(hostIds, names)
      query = (hostIds.map{ |hostId| "hostId=#{hostId}" } +
               names.map{ |name| "name=#{name}" }).join('&')

      response = client.get "/api/v0/tsdb/latest?#{query}" do |req|
        req.headers['X-Api-Key'] = @api_key
      end

      unless response.success?
        raise "/api/v0/tsdb/latest?#{query} failed: #{response.status}"
      end

      data = JSON.parse(response.body)
      data["tsdbLatest"]
    end

    def post_service_metrics(service_name, metrics)
      response = client.post "/api/v0/services/#{service_name}/tsdb" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = metrics.to_json
      end

      unless response.success?
        raise "POST /api/v0/services/#{service_name}/tsdb failed: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def define_graphs(graph_defs)
      response = client.post '/api/v0/graph-defs/create' do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = graph_defs.to_json
      end

      unless response.success?
        raise "POST /api/v0/graph-defs/create failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    def get_hosts(opts = {})
      response = client.get '/api/v0/hosts' do |req|
        req.headers['X-Api-Key'] = @api_key
        req.params['service']          = opts[:service]          if opts[:service]
        req.params['role']             = opts[:roles]            if opts[:roles]
        req.params['name']             = opts[:name]             if opts[:name]
        req.params['status']           = opts[:status]           if opts[:status]
        req.params['customIdentifier'] = opts[:customIdentifier] if opts[:customIdentifier]
      end

      unless response.success?
        raise "GET /api/v0/hosts failed: #{response.status}"
      end

      data = JSON.parse(response.body)
      data['hosts'].map{ |host_json| Host.new(host_json) }
    end

    def post_graph_annotation(annotation)
      response = client.post '/api/v0/graph-annotations' do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = annotation.to_json
      end

      unless response.success?
        raise "POST /api/v0/graph-annotations failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    def list_metadata(host_id)
      response = client.get "/api/v0/hosts/#{host_id}/metadata" do |req|
        req.headers['X-Api-Key'] = @api_key
      end

      unless response.success?
        raise "GET /api/v0/hosts/#{host_id}/metadata failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    def get_metadata(host_id, namespace)
      response = client.get "/api/v0/hosts/#{host_id}/metadata/#{namespace}" do |req|
        req.headers['X-Api-Key'] = @api_key
      end

      unless response.success?
        raise "GET /api/v0/hosts/#{host_id}/metadata/#{namespace} failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    def update_metadata(host_id, namespace, data)
      response = client.put "/api/v0/hosts/#{host_id}/metadata/#{namespace}" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = data.to_json
      end

      unless response.success?
        raise "POST /api/v0/hosts/#{host_id}/metadata/#{namespace} failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    def delete_metadata(host_id, namespace)
      response = client.delete "/api/v0/hosts/#{host_id}/metadata/#{namespace}" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
      end

      unless response.success?
        raise "DELETE /api/v0/hosts/#{host_id}/metadata/#{namespace} failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    private

    def client
      @client ||= http_client
    end

    def http_client
      Faraday.new(:url => @origin) do |faraday|
        faraday.response :logger if ENV['DEBUG']
        faraday.adapter Faraday.default_adapter
        faraday.options.params_encoder = Faraday::FlatParamsEncoder
        faraday.options.timeout        = @timeout
        faraday.options.open_timeout   = @open_timeout
      end
    end

  end

end
