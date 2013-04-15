require 'riemann/client'

module RailsRiemannMiddleware

  class Duration
    attr_reader :event, :env, :start_time
    
    def initialize(event, env, start_time)
      @event, @env, @start_time = event, env, start_time
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
        :tags        => ["duration"]
      }
      # ap msg
      msg
    end

  end
  
end
