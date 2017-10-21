module Mackerel

  class Dashboard
    attr_accessor :id, :title, :bodyMarkdown, :urlPath, :createdAt, :updatedAt
    def initialize(args = {})
      @id                              = args["id"]
      @title                           = args["title"]
      @bodyMarkdown                    = args["bodyMarkdown"]
      @urlPath                         = args["urlPath"]
      @createdAt                       = args["createdAt"]
      @updatedAt                       = args["updatedAt"]
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
    module Dashboard
      def post_dashboard(title, markdown, urlPath)
        command = ApiCommand.new(:post, '/api/v0/dashboards')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = {
            title: title,
            bodyMarkdown: markdown,
            urlPath: urlPath
        }.to_json
        data = command.execute(client)
        Mackerel::Dashboard.new(data)
      end

      def update_dashboard(dashboardId, title, markdown, urlPath)
        command = ApiCommand.new(:put, "/api/v0/dashboards/#{dashboardId}")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = {
            title: title,
            bodyMarkdown: markdown,
            urlPath: urlPath
        }.to_json
        data = command.execute(client)
        Mackerel::Dashboard.new(data)
      end

      def get_dashboards()
        command = ApiCommand.new(:get, '/api/v0/dashboards')
        command.headers['X-Api-Key'] = @api_key
        data = command.execute(client)
        data['dashboards'].map{ |d| Mackerel::Dashboard.new(d) }
      end

      def get_dashboard(dashboardId)
        command = ApiCommand.new(:get, "/api/v0/dashboards/#{dashboardId}")
        command.headers['X-Api-Key'] = @api_key
        data = command.execute(client)
        Mackerel::Dashboard.new(data)
      end

      def delete_dashboard(dashboardId)
        command = ApiCommand.new(:delete, "/api/v0/dashboards/#{dashboardId}")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        data = command.execute(client)
        Mackerel::Dashboard.new(data)
      end
    end
  end
end
