require 'cgi'
require 'pp'

module Mackerel
  class ApiCommand
    METHODS = [:get, :delete, :put, :post]
    JSON_CONTENT_TYPE = 'application/json'

    attr_accessor :headers, :body, :params, :query

    def initialize(method, path, api_key)
      @path = path
      @method = method
      @api_key = api_key

      @headers = {}
      @body = ''
      @params = {}
      @query = {}
    end

    def execute(client)
      return unless METHODS.include?(@method)

      request_path = @path
      request_path << "?#{make_escaped_query}" if @query.any?

      client_method = client.method(@method)
      response = client_method.call(request_path) do |req|
        req.headers.update @headers
        req.headers['x-api-key'] = @api_key
        req.headers['Content-Type'] ||= JSON_CONTENT_TYPE
        req.params = @params
        req.body = @body
      end
      JSON.parse(response.body)
    rescue Faraday::Error::ClientError => e
      begin
        body = JSON.parse(e.response[:body])
        message = body["error"].is_a?(Hash) ? body["error"]["message"] : body["error"]
        raise Mackerel::Error, "#{@method.upcase} #{@path} failed: #{e.response[:status]} #{message}"
      rescue JSON::ParserError
        # raise Mackerel::Error with original response body
        raise Mackerel::Error, "#{@method.upcase} #{@path} failed: #{e.response[:status]} #{e.response[:body]}"
      end
    end

    private

    def make_escaped_query
      @query.map{|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join("&")
    end

  end
end
