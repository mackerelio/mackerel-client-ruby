module Mackerel
  module REST
    module Downtime
      def post_downtime(downtime)
        command = ApiCommand.new(:post, "/api/v0/downtimes", @api_key)
        command.body = downtime.to_json
        command.execute(client)
      end

      def get_downtimes()
        command = ApiCommand.new(:get, "/api/v0/downtimes", @api_key)
        command.execute(client)
      end

      def update_downtime(downtime_id, downtime)
        command = ApiCommand.new(:put, "/api/v0/downtimes/#{downtime_id}", @api_key)
        command.body = downtime.to_json
        command.execute(client)
      end

      def delete_downtime(downtime_id)
        command = ApiCommand.new(:delete, "/api/v0/downtimes/#{downtime_id}", @api_key)
        command.execute(client)
      end
    end
  end
end