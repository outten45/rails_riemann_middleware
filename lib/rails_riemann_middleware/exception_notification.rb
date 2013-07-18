require 'socket'

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
        :host        => Socket.gethostname,
        :service     => "#{event.app_prefix} exception".strip,
        :state       => 'error',
        :description => backtrace,
        :tags        => ['exception'],
        :group       => exception.class,
        :request_id   => env['X-Request-Id']
      }
      msg
    end

    private

    def backtrace
      e = "#{exception.to_s}\n"
      e << exception.backtrace.join("\n")
    end
    
  end
  
end
