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
    config.riemann_options = (:riemann_host => "riemann_host_name")

    config.middleware.use(RailsRiemannMiddleware::Notifier, 
                          config.riemann_options)

If you would like to pull custom headers out of the env for reporting, 
you can add 

    :additional_headers => ['SOME_HEADER', 'SOME_OTHER_HEADER']

Those will be reported for both exceptions and duration events. If the
header is not defined, it will be reported as 'N/A'.

## ExceptionNotification 3.x API

If you, like us, are transitioning from the exception\_notification gem,
we support the API from the 3.x version of that gem for explicit calls
to the exception notifier. For example, if you are catching exceptions in
your controllers (preventing them from bubbling up automatically), you can
call:

    RailsRiemannMiddleware::RailsExceptionNotifier.exception_notification(env, error)

In your models or other background processes, you can call:

   RailsRiemannMiddleware::RailsExceptionNotifier.background_exception_notification(error) 

To use this extra functionality, you have to

    require 'rails_riemann_middleware/rails_exception_notifier'

## Running Tests

To run the tests use:

    $ bundle exec rake test

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
