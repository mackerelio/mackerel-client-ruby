module Mackerel

  class Client

    def list_metadata(host_id)
      response = client.get "/api/v0/hosts/#{host_id}/metadata" do |req|
        req.headers['X-Api-Key'] = @api_key
      end

      unless response.success?
        raise "GET /api/v0/hosts/#{host_id}/metadata failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    def get_metadata(host_id, namespace)
      response = client.get "/api/v0/hosts/#{host_id}/metadata/#{namespace}" do |req|
        req.headers['X-Api-Key'] = @api_key
      end

      unless response.success?
        raise "GET /api/v0/hosts/#{host_id}/metadata/#{namespace} failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    def update_metadata(host_id, namespace, data)
      response = client.put "/api/v0/hosts/#{host_id}/metadata/#{namespace}" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
        req.body = data.to_json
      end

      unless response.success?
        raise "POST /api/v0/hosts/#{host_id}/metadata/#{namespace} failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

    def delete_metadata(host_id, namespace)
      response = client.delete "/api/v0/hosts/#{host_id}/metadata/#{namespace}" do |req|
        req.headers['X-Api-Key'] = @api_key
        req.headers['Content-Type'] = 'application/json'
      end

      unless response.success?
        raise "DELETE /api/v0/hosts/#{host_id}/metadata/#{namespace} failed: #{response.status} #{response.body}"
      end

      JSON.parse(response.body)
    end

  end

end
