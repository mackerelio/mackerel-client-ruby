module Mackerel

  class Service

    attr_accessor :name, :memo, :roles

    def initialize(args = {})
      @name                            = args["name"]
      @memo                            = args["memo"]
      @roles                           = args["roles"]
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
    module Service

      def get_services()
        order = ApiOrder.new(:get, '/api/v0/services')
        order.headers['X-Api-Key'] = @api_key
        data = order.execute(client)
        data['services'].map {|s| Mackerel::Service.new(s) }
      end

      def get_roles(serviceName)
        order = ApiOrder.new(:get, "/api/v0/services/#{serviceName}/roles")
        order.headers['X-Api-Key'] = @api_key
        data = order.execute(client)
        data['roles'].map {|s| Mackerel::Role.new(s) }
      end

      def get_service_metric_names(serviceName)
        order = ApiOrder.new(:get, "/api/v0/services/#{serviceName}/metric-names")
        order.headers['X-Api-Key'] = @api_key
        data = order.execute(client)
        data['names']
      end

    end
  end
end

