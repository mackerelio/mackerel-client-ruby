require 'faraday'
require 'uri'

require 'json' unless defined? ::JSON

require 'mackerel/api_command'

require 'mackerel/role'
require 'mackerel/host'
require 'mackerel/monitor'
require 'mackerel/monitoring'
require 'mackerel/service'
require 'mackerel/alert'
require 'mackerel/annotation'
require 'mackerel/user'
require 'mackerel/invitation'
require 'mackerel/organization'
require 'mackerel/dashboard'
require 'mackerel/metric'
require 'mackerel/metadata'
require 'mackerel/notification_group'
require 'mackerel/channel'

module Mackerel
  class Client
    include Mackerel::REST::Alert
    include Mackerel::REST::Annotation
    include Mackerel::REST::Dashboard
    include Mackerel::REST::Host
    include Mackerel::REST::Invitation
    include Mackerel::REST::Metric
    include Mackerel::REST::Monitor
    include Mackerel::REST::Monitoring
    include Mackerel::REST::Organization
    include Mackerel::REST::Service
    include Mackerel::REST::User
    include Mackerel::REST::Metadata
    include Mackerel::REST::Channel
    include Mackerel::REST::NotificationGroup

    def initialize(args = {})
      @origin       = args[:mackerel_origin]  || 'https://api.mackerelio.com'
      @api_key      = args[:mackerel_api_key] || raise(ERROR_MESSAGE_FOR_API_KEY_ABSENCE)
      @timeout      = args[:timeout]          || 30 # Ref: apiRequestTimeout at mackerel-agent
      @open_timeout = args[:open_timeout]     || 30 # Ref: apiRequestTimeout at mackerel-agent
    end

    private
    ERROR_MESSAGE_FOR_API_KEY_ABSENCE = "API key is absent. Set your API key in a environment variable called MACKEREL_APIKEY."

    def client
      @client ||= http_client
    end

    def http_client
      Faraday.new(:url => @origin) do |faraday|
        faraday.response :logger if ENV['DEBUG']
        faraday.adapter Faraday.default_adapter
        faraday.options.params_encoder = Faraday::FlatParamsEncoder
        faraday.options.timeout        = @timeout
        faraday.options.open_timeout   = @open_timeout
      end
    end
  end
end
