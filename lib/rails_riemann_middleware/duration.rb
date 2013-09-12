require "rails_riemann_middleware/headers"

module RailsRiemannMiddleware

  class Duration
    attr_reader :event, :env, :start_time, :headers
    
    def initialize(event, env, start_time, options={})
      @event, @env, @start_time = event, env, start_time
      @headers = options.fetch(:headers, [])
    end

    def send
      event << message
    end
    
    def message
      end_time = Time.new
      duration = (end_time - start_time)
      msg = {
        :host        => env['HTTP_HOST'],
        :service     => "#{event.app_prefix} request duration".strip,
        :state       => 'info',
        :metric      => duration,
        :tags        => ["duration"],
        :description => Headers.new(env, headers).to_s
      }
      msg
    end

  end
  
end
