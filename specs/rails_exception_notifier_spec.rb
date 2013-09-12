require_relative 'spec_helper'
require 'rails_riemann_middleware'
require 'rails_riemann_middleware/rails_exception_notifier'

class DummyAppConfig
  def riemann_options
    {}
  end
end

class DummyApplication
  def config
    DummyAppConfig.new
  end
end

module Rails
  def self.application
    DummyApplication.new
  end
end

module RailsRiemannMiddleware
  describe RailsExceptionNotifier do
    let(:exception_notification_new) { MiniTest::Mock.new }
    let(:error) { Object.new }

    # Support ExceptionNotification gem API
    describe '#exception_notification' do
      it "creates an ExceptionNotification with an event" do
        env = Object.new
        exception_notification_new.expect(:call, nil) do |a1, a2, a3|
          a1.kind_of?(Event) && a2 == env && a3 == error
        end

        ExceptionNotification.stub(:new, exception_notification_new) do
          RailsExceptionNotifier.exception_notification(env, error)
        end
        exception_notification_new.verify
      end
    end

    describe "#background_exception_notification" do
      it "creates an ExceptionNotification with event and empty env" do
        exception_notification_new.expect(:call, nil) do |a1, a2, a3|
          a1.kind_of?(Event) && a2 == {} && a3 == error
        end

        ExceptionNotification.stub(:new, exception_notification_new) do
          RailsExceptionNotifier.background_exception_notification(error)
        end
        exception_notification_new.verify
      end
    end
  end
end
