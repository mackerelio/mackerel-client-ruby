require 'faraday'
require 'uri'

require 'json' unless defined? ::JSON
require 'mackerel/host'

module Mackerel

  class Client

    ERROR_MESSAGE_FOR_API_KEY_ABSENCE = "API key is absent. Set your API key in a environment variable called MACKEREL_APIKEY."

    def initialize(args = {})
      @origin  = args[:mackerel_origin] || 'https://mackerel.io'
      @api_key = args[:mackerel_api_key] || raise(ERROR_MESSAGE_FOR_API_KEY_ABSENCE)
    end

    def get_host(host_id)
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

    def retire_host(host_id)
      response = client.post "/api/v0/hosts/#{host_id}/retire" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = { }.to_json
      end

      unless response.success?
        raise "POST /api/v0/hosts/#{host_id}/retire faild: #{response.status}"
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
        raise "POST /api/v0/tsdb faild: #{response.status}"
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
        raise "/api/v0/tsdb/latest?#{query} faild: #{response.status}"
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
        raise "POST /api/v0/services/#{service_name}/tsdb faild: #{response.status}"
      end

      data = JSON.parse(response.body)
    end

    def get_hosts(opts = {})
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

    def client
      @client ||= http_client
    end

    def http_client
      Faraday.new(:url => @origin) do |faraday|
        faraday.response :logger if ENV['DEBUG']
        faraday.adapter Faraday.default_adapter
        faraday.options.params_encoder = Faraday::FlatParamsEncoder
      end
    end

  end

end
