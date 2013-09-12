require "rails_riemann_middleware/headers"

module RailsRiemannMiddleware

  class ExceptionNotification
    attr_reader :event, :env, :exception, :headers

    def initialize(event, env, exception, options={})
      @event, @env, @exception = event, env, exception
      @headers = options.fetch(:headers, [])
    end

    def send
      event << message
    end

    def deliver
      send
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
      e += Headers.new(env, headers).to_a
      e << "----------------------------------------\n"
      e += exception.backtrace
      e.join("\n")[0..8000]
    end

  end

end
