module Mackerel

  class Alert
    attr_accessor :id, :status, :monitorId, :type, :hostId, :value, :message, :reason, :openedAt, :closedAt

    def initialize(args = {})
      @id                              = args["id"]
      @status                          = args["status"]
      @monitorId                       = args["monitorId"]
      @type                            = args["type"]
      @hostId                          = args["hostId"]
      @value                           = args["value"]
      @message                         = args["message"]
      @reason                          = args["reason"]
      @openedAt                        = args["openedAt"]
      @closedAt                        = args["closedAt"]
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
    module Alert
      def get_alerts()
        order = ApiOrder.new(:get, "/api/v0/alerts")
        order.headers['X-Api-Key'] = @api_key
        data = order.execute(client)
        data["alerts"].map { |a| Mackerel::Alert.new(a) }
      end

      def close_alert(alertId, reason)
        order = ApiOrder.new(:post, "/api/v0/alerts/#{alertId}/close")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = { reason: reason.to_s }.to_json
        data = order.execute(client)
        Mackerel::Alert.new(data)
      end
    end
  end
end
