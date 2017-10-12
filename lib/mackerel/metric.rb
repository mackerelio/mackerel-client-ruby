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
        order = ApiOrder.new(:post, '/api/v0/tsdb')
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = metrics.to_json
        data = order.execute(client)
      end

      def get_host_metrics(host_id, name, from, to)
        order = ApiOrder.new(:get, "/api/v0/hosts/#{host_id}/metrics")
        order.headers['X-Api-Key'] = @api_key
        order.params['name'] = name
        order.params['from'] = from
        order.params['to'] = to
        data = order.execute(client)
        data["metrics"]
      end

      def get_latest_host_metrics(host_id, name)
        order = ApiOrder.new(:get, "/api/v0/tsdb/latest")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.params['hostId'] = host_id 
        order.params['name'] = name
        data = order.execute(client)
        data["tsdbLatest"]
      end

      def post_service_metrics(service_name, metrics)
        order = ApiOrder.new(:post, "/api/v0/services/#{service_name}/tsdb")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = metrics.to_json
        data = order.execute(client)
      end

      def get_service_metrics(service_name, name, from, to)
        order = ApiOrder.new(:get, "/api/v0/services/#{service_name}/metrics")
        order.headers['X-Api-Key'] = @api_key
        order.params['name'] = name
        order.params['from'] = from
        order.params['to'] = to
        data = order.execute(client)
        data["metrics"]
      end

      def define_graphs(graph_defs)
        order = ApiOrder.new(:post, '/api/v0/graph-defs/create')
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = graph_defs.to_json
        data = order.execute(client)
      end
    end
  end
end

