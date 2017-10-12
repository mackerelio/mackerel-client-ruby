module Mackerel
  class Role 

    attr_accessor :name, :memo

    def initialize(args = {})
      @name                            = args["name"]
      @memo                            = args["memo"]
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
end

