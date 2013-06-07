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
      e = "#{exception.to_s}\n"
      e << "----------------------------------------\n"
      e << " request_method: #{env["REQUEST_METHOD"]}\n"
      e << " request_uri: #{env["REQUEST_URI"]}\n"
      e << " path_info: #{env["PATH_INFO"]}\n"
      e << " real_ip: #{env["HTTP_X_REAL_IP"]}\n"
      e << " http_user_agent: #{env["HTTP_USER_AGENT"]}\n"
      e << " http_referer: #{env["HTTP_REFERER"]}\n"
      e << "----------------------------------------\n\n"
        e << exception.backtrace.join("\n")
      e[0..8000]
    end

  end

end
