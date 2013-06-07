require "rails_riemann_middleware/version"
require "rails_riemann_middleware/event"
require "rails_riemann_middleware/duration"
require "rails_riemann_middleware/exception_notification"

module RailsRiemannMiddleware

  class Notifier
    attr_reader :event, :send_durations, :send_exceptions

    def initialize(app, options = {})
      @app, @options = app, options
      @send_durations  = options.fetch(:send_durations, true)
      @send_exceptions = options.fetch(:send_exceptions, true)
      @event = Event.new(options)
    end

    def call(env)
      start_time = Time.now
      @app.call(env)
    rescue Exception => exception
      ExceptionNotification.new(event, env, exception).send if send_exceptions
      raise exception
    ensure
      Duration.new(event, env, start_time).send if send_durations
    end

  end

end
