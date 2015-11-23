require 'webhook_handler/version'
require 'sidekiq'
require 'sinatra'

module WebhookHandler
  def self.included(klass)
    klass.extend self
    klass.include Sidekiq::Worker
    klass.extend Sinatra::Delegator
    klass.instance_eval do
      get '/' do
        'Send a POST request to this URL to trigger the webhook'
      end

      post '/' do
        klass.perform_async
        'ok'
      end
    end
  end

  def call(*args)
    Sinatra::Application.call(*args)
  end
end
