module Mackerel

  class Host

    MACKEREL_INTERFACE_NAME_PATTERN = /^eth\d/
    attr_accessor :name, :type, :status, :memo, :isRetired, :id, :createdAt, :roles, :interfaces

    def initialize(args = {})
      @hash       = args
      @name       = args["name"]
      @meta       = args["meta"]
      @type       = args["type"]
      @status     = args["status"]
      @memo       = args["memo"]
      @isRetired  = args["isRetired"]
      @id         = args["id"]
      @createdAt  = args["createdAt"]
      @roles      = args["roles"]
      @interfaces = args["interfaces"]
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
        order = ApiOrder.new(:post, "/api/v0/hosts")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = host.to_json
        data = order.execute(client)
      end
  
      def update_host(host_id, host)
        order = ApiOrder.new(:put, "/api/v0/hosts/#{host_id}")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = host.to_json
        data = order.execute(client)
      end
  
      def update_host_roles(host_id, roles)
        roles = [roles] if roles.is_a?(String)
        order = ApiOrder.new(:put, "/api/v0/hosts/#{host_id}/role-fullnames")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = { "roleFullnames" => roles }.to_json
        data = order.execute(client)
      end
  
      def get_host(host_id)
        order = ApiOrder.new(:get, "/api/v0/hosts/#{host_id}")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        data = order.execute(client)
        Mackerel::Host.new(data['host'])
      end
  
      def get_host_metadata(host_id, namespace)
        order = ApiOrder.new(:get, "/api/v0/hosts/#{host_id}/metadata/#{namespace}")
        order.headers['X-Api-Key'] = @api_key
        data = order.execute(client)
      end

      def list_host_metadata(host_id)
        order = ApiOrder.new(:get, "/api/v0/hosts/#{host_id}/metadata")
        order.headers['X-Api-Key'] = @api_key
        data = order.execute(client)
        data['metadata']
      end
  
      def update_host_status(host_id, status)
        unless [:standby, :working, :maintenance, :poweroff].include?(status.to_sym)
          raise "no such status: #{status}"
        end
  
        order = ApiOrder.new(:post, "/api/v0/hosts/#{host_id}/status")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = { "status" => status }.to_json
        data = order.execute(client)
      end
  
      def retire_host(host_id)
        order = ApiOrder.new(:post, "/api/v0/hosts/#{host_id}/retire")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = { }.to_json
        data = order.execute(client)
      end
  
      def put_host_metadata(host_id, namespace, metadata)
        order = ApiOrder.new(:put, "/api/v0/hosts/#{host_id}/metadata/#{namespace}")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = metadata.to_json
        data = order.execute(client)
      end
  
      def get_hosts(opts = {})
        order = ApiOrder.new(:get, '/api/v0/hosts')
        order.headers['X-Api-Key'] = @api_key
        order.params['service']    = opts[:service] if opts[:service]
        order.params['role']       = opts[:roles]   if opts[:roles]
        order.params['name']       = opts[:name]    if opts[:name]
        order.params['status']     = opts[:status]  if opts[:status]
        data = order.execute(client)
        data['hosts'].map{ |host_json| Mackerel::Host.new(host_json) }
      end
  
      def get_host_metric_names(host_id)
        order = ApiOrder.new(:get, "/api/v0/hosts/#{host_id}/metric-names")
        order.headers['X-Api-Key'] = @api_key
        data = order.execute(client)
        data["names"]
      end
  
      def delete_host_metadata(host_id, namespace)
        order = ApiOrder.new(:delete, "/api/v0/hosts/#{host_id}/metadata/#{namespace}")
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        data = order.execute(client)
      end
    end
  end
end
