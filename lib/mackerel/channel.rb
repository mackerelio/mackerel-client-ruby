module Mackerel
  class Channel
    attr_accessor :id, :name, :type, :suspendedAt
    def initialize(args = {})
      @id                 = args["id"]
      @name               = args["name"]
      @type               = args["type"]
      @suspendedAt        = args["suspendedAt"]
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
    module Channel
      def get_channels()
        command = ApiCommand.new(:get, '/api/v0/channels', @api_key)
        data = command.execute(client)
        data['channels'].map{|d| Mackerel::Channel.new(d) }
      end
    end
  end
end
