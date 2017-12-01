module Mackerel
  module REST
    module Monitoring

      def post_monitoring_check_report(reports)
        command = ApiCommand.new(:post,'/api/v0/monitoring/checks/report', @api_key)
        command.body = reports.to_json
        command.execute(client)
      end

    end
  end
end
