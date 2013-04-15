require 'riemann/client'

module RailsRiemannMiddleware

  class Event
    attr_reader :client, :options, :reporting_host, :tags
    
    def initialize(options)
      @options         = options
      @client          = create_riemann_client
      @reporting_host  = options[:reporting_host]
      @tags            = options.fetch(:tags, [])
    end

    def <<(msg)
      msg[:tags] += Array(tags)
      client << {:time => time_for_client, :host => reporting_host}.merge(msg)
    end

    def app_prefix
      options.fetch(:app_prefix, "")
    end

    private

    def time_for_client
      Time.now.to_i - 10
    end

    def create_riemann_client
      riemann_host    = options.fetch(:riemann_host, "127.0.0.1")
      riemann_port    = options.fetch(:riemann_port, "5555")

      Riemann::Client.new(:host => riemann_host, :port => riemann_port)
    end
    
  end
  
end
