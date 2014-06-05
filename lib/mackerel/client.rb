require 'faraday'
require 'uri'

require 'json' unless defined? ::JSON
require 'mackerel/host'

module Mackerel

  class Client

    def initialize(args = {})
      @origin  = args[:mackerel_origin] || 'https://mackerel.io'
      @api_key = args[:mackerel_api_key]
    end

    def get_host(host_id)
      client = http_client

      response = client.get "/api/v0/hosts/#{host_id}" do |req|
        req.headers['X-Api-Key'] = @api_key
      end

      unless response.success?
        raise "GET /api/v0/hosts/#{host_id} faild: #{response.status}"
      end

      data = JSON.parse(response.body)
      Host.new(data['host'])
    end

    def update_host_status(host_id, status)
      unless [:standby, :working, :maintenance, :poweroff].include?(status.to_sym)
        raise "no such status: #{status}"
      end

      client = http_client

      response = client.post "/api/v0/hosts/#{host_id}/status" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = { "status" => status }.to_json
      end

      unless response.success?
        raise "POST /api/v0/hosts/#{host_id}/status faild: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def post_metrics(metrics)
      client = http_client

      response = client.post '/api/v0/tsdb' do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = metrics.to_json
      end

      unless response.success?
        raise "POST /api/v0/tsdb faild: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def post_service_metrics(service_name, metrics)
      client = http_client

      response = client.post "/api/v0/services/#{service_name}/tsdb" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = metrics.to_json
      end

      unless response.success?
        raise "POST /api/v0/tsdb faild: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def get_hosts(opts = {})
      client = http_client

      response = client.get '/api/v0/hosts.json' do |req|
        req.headers['X-Api-Key'] = @api_key
        req.params['service']    = opts[:service] if opts[:service]
        req.params['role']       = opts[:roles]   if opts[:roles]
        req.params['name']       = opts[:name]    if opts[:name]
      end

      unless response.success?
        raise "GET /api/v0/hosts.json faild: #{response.status}"
      end

      data = JSON.parse(response.body)
      data['hosts'].map{ |host_json| Host.new(host_json) }
    end

    private

    def http_client
      Faraday.new(:url => @origin) do |faraday|
        faraday.response :logger if ENV['DEBUG']
        faraday.adapter Faraday.default_adapter
        faraday.options.params_encoder = Faraday::FlatParamsEncoder
      end
    end

  end

end
