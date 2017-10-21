module Mackerel

  class Monitor

    attr_accessor :id, :type, :name, :duration, :metric, :url, :service, :maxCheckAttempts, :operator, :warning, :critical, :responseTimeWarning, :responseTimeCritical, :responseTimeDuration, :certificationExpirationWarning, :certificationExpirationCritical, :containsString, :expression, :notificationInterval, :scopes, :excludeScopes, :isMute

    def initialize(args = {})
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
      instance_variables.flat_map do |name|
        respond_to?(name[1..-1]) ? [name[1..-1]] : []
      end.each_with_object({}) do |name, hash| 
        hash[name] = public_send(name)
      end.delete_if { |key, val| val == nil }
    end

    def to_json(options = nil)
      return to_h.to_json(options)
    end

  end

  module REST
    module Monitor

      def post_monitor(monitor)
        command = ApiCommand.new(:post, '/api/v0/monitors')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = monitor.to_json
        data = command.execute(client)
        Mackerel::Monitor.new(data)
      end

      def post_monitoring_check_report(reports)
        command = ApiCommand.new(:post,'/api/v0/monitoring/checks/report')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = reports.to_json
        data = command.execute(client)
      end

      def get_monitors()
        command = ApiCommand.new(:get,'/api/v0/monitors')
        command.headers['X-Api-Key'] = @api_key
        data = command.execute(client)
        data['monitors'].map{ |m| Mackerel::Monitor.new(m) }
      end

      def update_monitor(monitor_id, monitor)
        command = ApiCommand.new(:put, "/api/v0/monitors/#{monitor_id}")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = monitor.to_json
        data = command.execute(client)
        Mackerel::Monitor.new(data)
      end

      def delete_monitor(monitor_id)
        command = ApiCommand.new(:delete, "/api/v0/monitors/#{monitor_id}")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        data = command.execute(client)
        Mackerel::Monitor.new(data)
      end
    end
  end
end
