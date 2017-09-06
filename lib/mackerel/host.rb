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

end
