require 'optparse'
require 'pp'
require 'json'

module Mackerel

  class Runner
    attr_reader :args

    def initialize(args)

      args.unshift 'help' if args.empty?

      @args = args
      cmd = args.shift

      # p cmd
      if Runner.method_defined?(cmd) and cmd != 'run'
        # args.replace expanded_args if expanded_args
        send(cmd, args)
      else
        abort "Error: `#{cmd}` command not found."
      end
    end

    # Shortcut
    def self.execute(args)
      new(args)
    end

    def help(args)
      puts <<-EOS
#{$0}: Command line interface for Mackerel (https://mackerel.io/).
  Get host(s) information from hostname or service, role.
    mkr host info [--name foo] [--service service] [--role role]

  Set status of a host
    mkr host status --host-id foo --status working

  Authentication
    API key must be set to the environment variable as follows.
      export MACKEREL_APIKEY=foobar

      EOS
    end

    # mkr host status --host-id foo
    def host(args)
      mc = Mackerel::Client.new(:mackerel_api_key => ENV['MACKEREL_APIKEY'])
      params = {}
      opt = OptionParser.new
      opt.on('--host-id HOSTID'){|v| params[:hostid] = v }

      cmd = args.shift
      case cmd
      when 'status'
          opt.on('--status STATUS'){|v| params[:status] = v }
          opt.parse!(args)
          if params[:status]
            begin
              res = mc.update_host_status(params[:hostid], params[:status])
              puts "Updated to '#{params[:status]}'"
            rescue => msg
              abort "Error: #{msg}"
            end
          else
            begin
              res = mc.get_hosts(:hostid => params[:hostid])[0]
              puts "#{res.status}"
            rescue => msg
              abort "Error: #{msg}"
            end

          end
 
      when 'info'
          opt.on('--service SERVICE'){|v| params[:service] = v }
          opt.on('--role ROLE')      {|v| params[:role] = v }
          opt.on('--name NAME')      {|v| params[:name] = v }
          opt.parse!(args)
          begin
            res = mc.get_hosts(params)
          rescue => msg
            abort "Error: #{msg}"
          end
          res.each do |res|
            puts <<-EOS
name: #{res.name}, status: #{res.status}, id: #{res.id}, roles: #{res.roles}
          EOS
          end
      else
        abort "Error: `#{command}` command not found for host."
      end
    end

  end

end

