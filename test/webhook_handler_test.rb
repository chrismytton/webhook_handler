require 'simplecov'
SimpleCov.start if ENV['COVERAGE']

require 'test_helper'
require 'rack/test'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

class MyApp
  include WebhookHandler

  def perform
  end
end

class AnotherApp
  include WebhookHandler

  def handle_webhook
    request.body.rewind
    payload = JSON.parse(request.body.read)
    self.class.perform_async(payload['message'])
  end

  def perform(message)
  end
end

class WebhookHandlerTest < Minitest::Test
  include Rack::Test::Methods

  def app
    MyApp
  end

  def after_teardown
    Sidekiq::Worker.clear_all
  end

  def test_that_it_has_a_version_number
    refute_nil ::WebhookHandler::VERSION
  end

  def test_it_is_a_sidekiq_worker
    assert_equal 0, app.jobs.size
    app.perform_async
    assert_equal 1, app.jobs.size
  end

  def test_homepage
    get '/'
    assert_equal 'Send a POST request to this URL to trigger the webhook', last_response.body
  end

  def test_triggering_webhook
    assert_equal 0, app.jobs.size
    post '/'
    assert_equal 1, app.jobs.size
  end

  class ComplexWebhookHandling < Minitest::Test
    include Rack::Test::Methods

    def app
      AnotherApp
    end

    def test_overriding_handle_webhook
      post '/', '{"message": "Hello, world!"}', 'CONTENT_TYPE' => 'application/json'
      job = app.jobs.last
      assert_equal ['Hello, world!'], job['args']
    end
  end
end
