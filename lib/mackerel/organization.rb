module Mackerel
  class Organization
    attr_accessor :name
    def initialize(args = {})
      @name               = args["name"]
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
    module Organization

      def get_organization()
        order = ApiOrder.new(:get, '/api/v0/org')
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        data = order.execute(client)
        Mackerel::Organization.new(data)
      end

    end
  end
end
