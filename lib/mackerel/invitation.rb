module Mackerel
  class Invitation
  end

  module REST
    module Invitation
      def post_invitation(email, authority)
        order = ApiOrder.new(:post, '/api/v0/invitations')
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = { 
          email: email.to_s,
          authority: authority.to_s
        }.to_json
        data = order.execute(client)
      end
  
      def revoke_invitation(email)
        order = ApiOrder.new(:post, '/api/v0/invitations/revoke')
        order.headers['X-Api-Key'] = @api_key
        order.headers['Content-Type'] = 'application/json'
        order.body = { email: email.to_s }.to_json
        data = order.execute(client)
      end
    end
  end
end
