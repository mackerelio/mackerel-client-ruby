module Mackerel

  class NotificationGroup
    attr_accessor :id, :name, :notificationLevel, :childNotificationGroupIds, :childChannelIds, :monitors, :services
    def initialize(args = {})
      @id                              = args["id"]
      @name                            = args["name"]
      @notificationLevel               = args["notificationLevel"]
      @childNotificationGroupIds       = args["childNotificationGroupIds"]
      @childChannelIds                 = args["childChannelIds"]
      @monitors                        = args["monitors"]
      @services                        = args["services"]
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
    module NotificationGroup
      def post_notification_group(notification_group)
        command = ApiCommand.new(:post, '/api/v0/notification-groups', @api_key)
        command.body = notification_group.to_json
        data = command.execute(client)
        Mackerel::NotificationGroup.new(data)
      end
  
      def get_notification_groups()
        command = ApiCommand.new(:get, '/api/v0/notification-groups', @api_key)
        data = command.execute(client)
        data['notificationGroups'].map{|a| Mackerel::NotificationGroup.new(a)}
      end
  
      def update_notification_group(notification_group_id, notification_group)
        command = ApiCommand.new(:put, "/api/v0/notification-groups/#{notification_group_id}", @api_key)
        command.body = notification_group.to_json
        data = command.execute(client)
        Mackerel::NotificationGroup.new(data)
      end
  
      def delete_notification_group(notification_group_id)
        command = ApiCommand.new(:delete, "/api/v0/notification-groups/#{notification_group_id}", @api_key)
        data = command.execute(client)
        Mackerel::NotificationGroup.new(data)
      end
    end
  end
end
