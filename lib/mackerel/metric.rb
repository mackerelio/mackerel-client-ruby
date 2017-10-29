module Mackerel
  module REST
    module Metric
      def post_metrics(metrics)
        command = ApiCommand.new(:post, '/api/v0/tsdb', @api_key, @content_type)
        command.body = metrics.to_json
        data = command.execute(client)
      end

      def get_host_metrics(host_id, name, from, to)
        command = ApiCommand.new(:get, "/api/v0/hosts/#{host_id}/metrics", @api_key, @content_type)
        command.params['name'] = name
        command.params['from'] = from
        command.params['to'] = to
        data = command.execute(client)
        data["metrics"]
      end

      def get_latest_metrics(host_id, name)
        command = ApiCommand.new(:get, "/api/v0/tsdb/latest", @api_key, @content_type)
        command.params['hostId'] = host_id
        command.params['name'] = name
        data = command.execute(client)
        data["tsdbLatest"]
      end

      def post_service_metrics(service_name, metrics)
        command = ApiCommand.new(:post, "/api/v0/services/#{service_name}/tsdb", @api_key, @content_type)
        command.body = metrics.to_json
        data = command.execute(client)
      end

      def get_service_metrics(service_name, name, from, to)
        command = ApiCommand.new(:get, "/api/v0/services/#{service_name}/metrics", @api_key, @content_type)
        command.params['name'] = name
        command.params['from'] = from
        command.params['to'] = to
        data = command.execute(client)
        data["metrics"]
      end

      def define_graphs(graph_defs)
        command = ApiCommand.new(:post, '/api/v0/graph-defs/create', @api_key, @content_type)
        command.body = graph_defs.to_json
        data = command.execute(client)
      end
    end
  end
end

