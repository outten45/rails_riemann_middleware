module RailsRiemannMiddleware
  class RailsExceptionNotifier
    def self.exception_notification(env, exception, options={})
      app = options.fetch(:app) {Rails.application}
      options = app.config.riemann_options.merge(options)
      headers = options.delete(:additional_headers)

      event = Event.new(options)

      ExceptionNotification.new(event, env, exception,
                                headers: headers)
    end

    def self.background_exception_notification(exception, options={})
      app = options.fetch(:app) {Rails.application}
      options = app.config.riemann_options.merge(options)
      headers = options.delete(:additional_headers)

      event = Event.new(options)
      env = {}

      ExceptionNotification.new(event, env, exception)
    end
  end
end
