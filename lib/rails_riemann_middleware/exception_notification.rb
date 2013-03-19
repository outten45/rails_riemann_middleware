module RailsRiemannMiddleware
  
  class ExceptionNotification
    attr_reader :event, :env, :exception
    
    def initialize(event, env, exception)
      @event, @env, @exception = event, env, exception
    end

    def send
      event << message
    end
    
    def message
      msg = {
        :host        => env['HTTP_HOST'],
        :service     => "#{event.app_prefix} exception".strip,
        :state       => 'error',
        :description => backtrace,
        :tags        => "exception"
      }
      # ap msg
      msg
    end

    private

    def backtrace
      e = "#{exception.to_s}\n"
      e << exception.backtrace.join("\n")
      e[0..8000]
    end
    
  end
  
end
