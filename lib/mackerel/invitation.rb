module Mackerel
  class Invitation
  end

  module REST
    module Invitation
      def post_invitation(email, authority)
        command = ApiCommand.new(:post, '/api/v0/invitations')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = { 
          email: email.to_s,
          authority: authority.to_s
        }.to_json
        data = command.execute(client)
      end

      def revoke_invitation(email)
        command = ApiCommand.new(:post, '/api/v0/invitations/revoke')
        command.headers['X-Api-Key'] = @api_key
        command.headers['Content-Type'] = 'application/json'
        command.body = { email: email.to_s }.to_json
        data = command.execute(client)
      end
    end
  end
end
