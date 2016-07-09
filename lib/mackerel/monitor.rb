module Mackerel

  class Monitor

    attr_accessor :id, :type, :name, :duration, :metric, :url, :service, :maxCheckAttempts, :operator, :warning, :critical, :responseTimeWarning, :responseTimeCritical, :responseTimeDuration, :certificationExpirationWarning, :certificationExpirationCritical, :containsString, :expression, :notificationInterval, :scopes, :excludeScopes, :isMute

    def initialize(args = {})
      @hash                            = args
      @id                              = args["id"]
      @type                            = args["type"]
      @name                            = args["name"]
      @duration                        = args["duration"]
      @metric                          = args["metric"]
      @url                             = args["url"]
      @service                         = args["service"]
      @maxCheckAttempts                = args["maxCheckAttempts"]
      @operator                        = args["operator"]
      @warning                         = args["warning"]
      @critical                        = args["critical"]
      @responseTimeWarning             = args["responseTimeWarning"]
      @responseTimeCritical            = args["responseTimeCritical"]
      @responseTimeDuration            = args["responseTimeDuration"]
      @certificationExpirationWarning  = args["certificationExpirationWarning"]
      @certificationExpirationCritical = args["certificationExpirationCritical"]
      @containsString                  = args["containsString"]
      @expression                      = args["expression"]
      @notificationInterval            = args["notificationInterval"]
      @scopes                          = args["scopes"]
      @excludeScopes                   = args["excludeScopes"]
      @isMute                          = args["isMute"]
    end

    def to_h
      return @hash
    end

  end

  class Client

    def post_monitor(monitor)
      response = client.post "/api/v0/monitors" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = monitor.to_json
      end

      unless response.success?
        raise "POST /api/v0/monitors failed: #{response.status}"
      end

      data = JSON.parse(response.body)
      Monitor.new(data)
    end

    def get_monitors()
      response = client.get '/api/v0/monitors' do |req|
        req.headers['X-Api-Key'] = @api_key
      end

      unless response.success?
        raise "GET /api/v0/monitors failed: #{response.status}"
      end

      data = JSON.parse(response.body)
      data['monitors'].map{ |monitor_json| Monitor.new(monitor_json) }
    end

    def update_monitor(monitor_id, monitor)
      response = client.put "/api/v0/monitors/#{monitor_id}" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = monitor.to_json
      end

      unless response.success?
        raise "PUT /api/v0/monitors/#{monitor_id} failed: #{response.status}"
      end

      JSON.parse(response.body)
    end

    def delete_monitor(monitor_id)
      response = client.delete "/api/v0/monitors/#{monitor_id}" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
      end

      unless response.success?
        raise "DELETE /api/v0/monitors/#{monitor_id} failed: #{response.status}"
      end

      data = JSON.parse(response.body)
      Monitor.new(data)
    end

  end

end
