module Mackerel
  module REST
    module Invitation
      def post_invitation(email, authority)
        command = ApiCommand.new(:post, '/api/v0/invitations', @api_key)
        command.body = { 
          email: email.to_s,
          authority: authority.to_s
        }.to_json
        data = command.execute(client)
      end

      def revoke_invitation(email)
        command = ApiCommand.new(:post, '/api/v0/invitations/revoke', @api_key)
        command.body = { email: email.to_s }.to_json
        data = command.execute(client)
      end
    end
  end
end
