require "rails_riemann_middleware/version"
require 'riemann/client'

module RailsRiemannMiddleware

  class Notifier
    attr_reader :riemann_host, :riemann_port, :client, :reporting_host
    attr_reader :send_durations, :send_exceptions
    
    def initialize(app, options = {})
      @app, @options = app, options

      @riemann_host    = options.fetch(:riemann_host, "127.0.0.1")
      @riemann_port    = options.fetch(:riemann_port, "5555")
      @reporting_host  = options.fetch(:reporting_host, env['HTTP_HOST'])
      @send_durations  = options.fetch(:send_durations, true)
      @send_exceptions = options.fetch(:send_exceptions, true)

      puts "using riemann_host: #{riemann_host}"
      puts "using riemann_port: #{riemann_port}"
      @client = Riemann::Client.new(:host => riemann_host, :port => riemann_port)
    end

    def call(env)
      start_time = Time.now
      status, headers, body = @app.call(env)

      [status, headers, body]
    rescue Exception => exception
      puts "--------------------------------------------------"
      puts exception.to_s
      puts "--------------------"
      puts exception.backtrace
      puts "--------------------------------------------------"
      send_exception(env, exception) if send_exceptions
      raise exception
    ensure
      send_duration(env, start_time) if send_durations
    end

    def send_duration(env, start_time)
      end_time = Time.new
      duration = (end_time - start_time)
      client << {
        :host        => reporting_host,
        :service     => 'request_duration',
        :state       => 'info',
        :metric      => duration,
        :description => env['request duration'],
        :time        => time_for_client
      }
    end

    def send_exception(env, exception)
      msg = {
        :host        => reporting_host,
        :service     => 'caught exception',
        :state       => 'error',
        :description => exception.to_s,
        :time        => time_for_client
      }
      client << msg
    end

    def time_for_client
      Time.now.to_i - 10
    end
    
  end

end
