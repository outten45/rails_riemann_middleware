# -*- encoding: utf-8 -*-
require File.expand_path('../lib/rails_riemann_middleware/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Richard Outten"]
  gem.email         = ["engineering@crashlytics.com"]
  gem.description   = %q{Rack middleware for sending data to riemann}
  gem.summary       = %q{Rack middleware for sending data to riemann}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "crashlytics_rails_riemann_middleware"
  gem.require_paths = ["lib"]
  gem.version       = RailsRiemannMiddleware::VERSION

  gem.add_dependency("riemann-client", "~> 0.2.0")
end
