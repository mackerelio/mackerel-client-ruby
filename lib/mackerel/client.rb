require 'faraday'
require 'open-uri'
require 'uri'

require 'json' unless defined? ::JSON

module Mackerel

  class Client

    def initialize(args = {})
      @origin  = args[:mackerel_origin] || 'https://mackerel.io'
      @api_key = args[:mackerel_api_key]
    end

    def get_hosts(service = nil, roles = nil)
      mackerel = Faraday.new(:url => @origin) do |faraday|
        faraday.response :logger if ENV['DEBUG']
        faraday.adapter Faraday.default_adapter
        faraday.options.params_encoder = Faraday::FlatParamsEncoder
      end
      response = mackerel.get '/api/v0/hosts.json' do |req|
        req.headers['X-Api-Key'] = @api_key
        req.params['service']    = service if service
        req.params['role']       = roles   if roles
      end

      unless response.success?
        raise "GET /api/v0/hosts.json faield: #{response.status}"
      end

      data = JSON.parse(response.body)
      data['hosts']
    end

  end

end
