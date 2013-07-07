require "rails_riemann_middleware/headers"

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
        :tags        => ["exception"]
      }
      # ap msg
      msg
    end

    private

    def backtrace
      e = ["#{exception.to_s}"]
      e << "----------------------------------------"
      e += Headers.new(env).to_a
      e << "----------------------------------------\n"
      e += exception.backtrace
      e.join("\n")[0..8000]
    end

  end

end
