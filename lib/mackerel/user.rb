module Mackerel

  class User
    attr_accessor :id, :screenName, :email
    def initialize(args = {})
      @id                              = args["id"]
      @screenName                      = args["screenName"]
      @email                           = args["email"]
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
    module User

      def get_users()
        order = ApiOrder.new(:get, '/api/v0/users')
        order.headers['X-Api-Key'] = @api_key
        data = order.execute(client)
        data['users'].map{|u| Mackerel::User.new(u)}
      end
  
      def delete_user(user_id)
        order = ApiOrder.new(:delete, "/api/v0/users/#{user_id}")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        data = order.execute(client)
        Mackerel::User.new(data)
      end

    end
  end
end
