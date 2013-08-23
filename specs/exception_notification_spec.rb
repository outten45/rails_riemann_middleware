require_relative 'spec_helper'
require 'rails_riemann_middleware/exception_notification'

module RailsRiemannMiddleware
  describe ExceptionNotification do
    let(:event)     {MiniTest::Mock.new}
    let(:env)       { {'HTTP_HOST' => 'some_host'}}
    let(:exception) {Object.new}

    subject {ExceptionNotification.new(event, env, exception)}

    describe '#deliver' do
      it "adds its message to its event" do
        message = Object.new
        event.expect(:<<, Object.new, [message])
        subject.stub(:message, message) do
          subject.deliver
        end
        event.verify
      end
    end
  end
end
