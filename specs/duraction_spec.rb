require_relative 'spec_helper'
require 'minitest/mock'
require 'awesome_print'
require 'rails_riemann_middleware/duration'

describe RailsRiemannMiddleware::Duration do

  before do
    @start_time = Time.at(0)
    @env = {}
    @event = MiniTest::Mock.new
    @event.expect :app_prefix, "TEST APP"
  end

  it "should set the duration to 100 second" do
    d = RailsRiemannMiddleware::Duration.new(@event, @env, @start_time)
    Time.stub :new, Time.at(100) do
      d.message[:metric].must_equal 100
    end
  end

  it "should set the host to the value of HTTP_HOST" do
    @env["HTTP_HOST"] = "my.test.host"
    d = RailsRiemannMiddleware::Duration.new(@event, @env, @start_time)
    d.message[:host].must_equal "my.test.host"
  end

  it "should add the hash to the message array" do
    to_send = []
    def to_send.app_prefix
      "TEST APP"
    end
    d = RailsRiemannMiddleware::Duration.new(to_send, @env, @start_time)
    result = d.send
    result.size.must_equal 1
    result.first[:service].must_match /^TEST APP/
  end

  it "should have a state of 'info'" do
    d = RailsRiemannMiddleware::Duration.new(@event, @env, @start_time)
    d.message[:state].must_equal "info"
  end

  it "should have the REQUEST_METHOD in the description" do
    @env["REQUEST_METHOD"] = "POST"
    d = RailsRiemannMiddleware::Duration.new(@event, @env, @start_time)
    d.message[:description].must_match /request_method: POST/
  end

  it "should have the REQUEST_URI in the description" do
    @env["REQUEST_URI"] = "/this/is/uri"
    d = RailsRiemannMiddleware::Duration.new(@event, @env, @start_time)
    d.message[:description].must_match /request_uri: \/this\/is\/uri/
  end
  
end
