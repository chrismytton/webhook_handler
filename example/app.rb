lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'webhook_handler'
require 'json'

# Trigger this with:
# curl -X POST http://localhost:5000 -d '{"message": "bar"}'

class MyApp
  include WebhookHandler

  def handle_webhook
    request.body.rewind
    payload = JSON.parse(request.body.read)
    self.class.perform_async(payload['message'])
  end

  def perform(message)
    puts "Working hard! Message: #{message}"
    sleep 5
  end
end
