require 'cgi'
require 'pp'

module Mackerel
  class ApiCommand
    METHODS = [:get, :delete, :put, :post]

    attr_accessor :headers, :body, :params, :query

    def initialize(method, path, api_key, content_type = 'application/json')
      @path = path
      @method = method
      @api_key = api_key
      @content_type = content_type

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
        req.headers = @headers
        req.headers['x-api-key'] = @api_key
        req.headers['Content-Type'] = @content_type
        req.params = @params
        req.body = @body
      end
      check_status(response.status)

      JSON.parse(response.body)
    end

    private

    def check_status(status)
      case status
      when 200...300
        nil
      when 400
        message ="Invalid parameter"
        raise "#{@method.upcase} #{@path} failed: #{status} #{message}"
      when 403
        message ="Not authorized"
        raise "#{@method.upcase} #{@path} failed: #{status} #{message}"
      when 404
        message ="Resource not found"
        raise "#{@method.upcase} #{@path} failed: #{status} #{message}"
      when 409
        message ="Already exists"
        raise "#{@method.upcase} #{@path} failed: #{status} #{message}"
      end
    end

    def make_escaped_query
      @query.map{|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join("&")
    end

  end
end
