module Mackerel
  module REST
    module Metadata
      def get_metadata(host_id, namespace)
        command = ApiCommand.new(:get, "/api/v0/hosts/#{host_id}/metadata/#{namespace}", @api_key, @content_type)
        data = command.execute(client)
      end

      def list_metadata(host_id)
        command = ApiCommand.new(:get, "/api/v0/hosts/#{host_id}/metadata", @api_key, @content_type)
        data = command.execute(client)
      end

      def update_metadata(host_id, namespace, metadata)
        command = ApiCommand.new(:put, "/api/v0/hosts/#{host_id}/metadata/#{namespace}", @api_key, @content_type)
        command.body = metadata.to_json
        data = command.execute(client)
      end

      def delete_metadata(host_id, namespace)
        command = ApiCommand.new(:delete, "/api/v0/hosts/#{host_id}/metadata/#{namespace}", @api_key, @content_type)
        data = command.execute(client)
      end
    end
  end
end
