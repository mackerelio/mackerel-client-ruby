module Mackerel

  class Annotation
    attr_accessor :id, :service, :from, :to, :description, :title, :roles
    def initialize(args = {})
      @id                              = args["id"]
      @service                         = args["service"]
      @from                            = args["from"]
      @to                              = args["to"]
      @description                     = args["description"]
      @title                           = args["title"]
      @roles                           = args["roles"]
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
    module Annotation
      def post_annotation(annotation)
        command = ApiCommand.new(:post, '/api/v0/graph-annotations')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = annotation.to_json
        data = command.execute(client)
        Mackerel::Annotation.new(data)
      end

      def get_annotations(service, from, to)
        command = ApiCommand.new(:get, '/api/v0/graph-annotations')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.params['service'] = service
        command.params['from'] = from
        command.params['to'] = to
        data = command.execute(client)
        data['graphAnnotations'].map{|a| Mackerel::Annotation.new(a)}
      end

      def update_annotation(annotation_id, annotation)
        command = ApiCommand.new(:put, "/api/v0/graph-annotations/#{annotation_id}")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = annotation.to_json
        data = command.execute(client)
        Mackerel::Annotation.new(data)
      end

      def delete_annotation(annotation_id)
        command = ApiCommand.new(:delete, "/api/v0/graph-annotations/#{annotation_id}")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        data = command.execute(client)
        Mackerel::Annotation.new(data)
      end
    end
  end
end
