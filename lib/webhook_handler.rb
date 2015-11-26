require 'webhook_handler/version'
require 'sidekiq'
require 'rack'

module WebhookHandler
  attr_reader :request
  attr_reader :response

  def self.included(klass)
    klass.extend ClassMethods
    klass.send(:include, Sidekiq::Worker)
  end

  module ClassMethods
    def call(env)
      new.call(env)
    end
  end

  def call(env)
    @request = Rack::Request.new(env)
    @response = Rack::Response.new

    if request.get?
      response.write('Send a POST request to this URL to trigger the webhook')
    elsif request.post?
      if respond_to?(:handle_webhook)
        send(:handle_webhook)
      else
        _handle_webhook
      end
    end

    response.finish
  end

  def _handle_webhook
    response.write(self.class.perform_async)
  end
end
