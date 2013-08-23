require_relative 'spec_helper'
require 'rails_riemann_middleware'

module RailsRiemannMiddleware
  describe Notifier do
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
          Notifier.exception_notification(env, error)
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
          Notifier.background_exception_notification(error)
        end
        exception_notification_new.verify
      end
    end
  end
end
