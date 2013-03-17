# RailsRiemannMiddleware

A middleware to add to your rails application that sends request
duration metrics and exception notifications to
[Riemann](http://riemann.io/).

## Installation

Add this line to your application's Gemfile:

    gem 'rails_riemann_middleware'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_riemann_middleware

## Usage

Add the following to your specific rails enviroment.

    config.middleware.use(RailsRiemannMiddleware::Notifier, 
                          :riemann_host => "host_name")


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
