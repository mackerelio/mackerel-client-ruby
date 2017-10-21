module Mackerel
  class Metric
    attr_accessor :name, :values

    def initialize(args = {})
      @name                            = args["name"]
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
    module Metric
      def post_metrics(metrics)
        command = ApiCommand.new(:post, '/api/v0/tsdb')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = metrics.to_json
        data = command.execute(client)
      end

      def get_host_metrics(host_id, name, from, to)
        command = ApiCommand.new(:get, "/api/v0/hosts/#{host_id}/metrics")
        command.headers['X-Api-Key'] = @api_key
        command.params['name'] = name
        command.params['from'] = from
        command.params['to'] = to
        data = command.execute(client)
        data["metrics"]
      end

      def get_latest_host_metrics(host_id, name)
        command = ApiCommand.new(:get, "/api/v0/tsdb/latest")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.params['hostId'] = host_id
        command.params['name'] = name
        data = command.execute(client)
        data["tsdbLatest"]
      end

      def post_service_metrics(service_name, metrics)
        command = ApiCommand.new(:post, "/api/v0/services/#{service_name}/tsdb")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = metrics.to_json
        data = command.execute(client)
      end

      def get_service_metrics(service_name, name, from, to)
        command = ApiCommand.new(:get, "/api/v0/services/#{service_name}/metrics")
        command.headers['X-Api-Key'] = @api_key
        command.params['name'] = name
        command.params['from'] = from
        command.params['to'] = to
        data = command.execute(client)
        data["metrics"]
      end

      def define_graphs(graph_defs)
        command = ApiCommand.new(:post, '/api/v0/graph-defs/create')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = graph_defs.to_json
        data = command.execute(client)
      end
    end
  end
end

