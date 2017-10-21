module Mackerel

  class Host

    MACKEREL_INTERFACE_NAME_PATTERN = /^eth\d/
    attr_accessor :name, :type, :status, :memo, :isRetired, :id, :createdAt, :roles, :interfaces, :customIdentifier

    def initialize(args = {})
      @hash             = args
      @name             = args["name"]
      @meta             = args["meta"]
      @type             = args["type"]
      @status           = args["status"]
      @memo             = args["memo"]
      @isRetired        = args["isRetired"]
      @id               = args["id"]
      @createdAt        = args["createdAt"]
      @roles            = args["roles"]
      @interfaces       = args["interfaces"]
      @customIdentifier = args["customIdentifier"]
    end

    def ip_addr
      interface = @interfaces.find do |i|
        MACKEREL_INTERFACE_NAME_PATTERN === i['name']
      end
      interface['ipAddress'] if interface
    end

    def mac_addr
      interface = @interfaces.find do |i|
        MACKEREL_INTERFACE_NAME_PATTERN === i['name']
      end
      interface['macAddress'] if interface
    end

    def to_h
      return @hash
    end
  end

  module REST
    module Host

      def post_host(host)
        command = ApiCommand.new(:post, "/api/v0/hosts")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = host.to_json
        data = command.execute(client)
      end

      def update_host(host_id, host)
        command = ApiCommand.new(:put, "/api/v0/hosts/#{host_id}")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = host.to_json
        data = command.execute(client)
      end

      def update_host_roles(host_id, roles)
        roles = [roles] if roles.is_a?(String)
        command = ApiCommand.new(:put, "/api/v0/hosts/#{host_id}/role-fullnames")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = { "roleFullnames" => roles }.to_json
        data = command.execute(client)
      end

      def get_host(host_id)
        command = ApiCommand.new(:get, "/api/v0/hosts/#{host_id}")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        data = command.execute(client)
        Mackerel::Host.new(data['host'])
      end

      def update_host_status(host_id, status)
        unless [:standby, :working, :maintenance, :poweroff].include?(status.to_sym)
          raise "no such status: #{status}"
        end
  
        command = ApiCommand.new(:post, "/api/v0/hosts/#{host_id}/status")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = { "status" => status }.to_json
        data = command.execute(client)
      end

      def retire_host(host_id)
        command = ApiCommand.new(:post, "/api/v0/hosts/#{host_id}/retire")
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = { }.to_json
        data = command.execute(client)
      end

      def get_hosts(opts = {})
        command = ApiCommand.new(:get, '/api/v0/hosts')
        command.headers['X-Api-Key'] = @api_key
        command.params['service']    = opts[:service] if opts[:service]
        command.params['role']       = opts[:roles]   if opts[:roles]
        command.params['name']       = opts[:name]    if opts[:name]
        command.params['status']     = opts[:status]  if opts[:status]
        data = command.execute(client)
        data['hosts'].map{ |host_json| Mackerel::Host.new(host_json) }
      end

      def get_host_metric_names(host_id)
        command = ApiCommand.new(:get, "/api/v0/hosts/#{host_id}/metric-names")
        command.headers['X-Api-Key'] = @api_key
        data = command.execute(client)
        data["names"]
      end
    end
  end
end
