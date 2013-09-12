module RailsRiemannMiddleware

  class Headers

    attr_reader :env, :custom_headers
    
    def initialize(env, custom_headers=[])
      @env = env
      @custom_headers = custom_headers
    end

    def keys
      %w{REQUEST_METHOD REQUEST_URI PATH_INFO HTTP_X_REAL_IP HTTP_USER_AGENT HTTP_REFERER} + custom_headers
    end
    
    def to_a
      keys.map { |h| " #{h.downcase}: #{env.fetch(h, "N/A")}" }
    end

    def to_s
      to_a.join("\n")
    end
    
  end

end
