lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'webhook_handler'

class MyApp
  include WebhookHandler

  def perform
    puts "Working hard!"
    sleep 5
  end
end
