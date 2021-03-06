# WebhookHandler [![Build Status](https://travis-ci.org/chrismytton/webhook_handler.svg?branch=master)](https://travis-ci.org/chrismytton/webhook_handler)

Combines Rack and Sidekiq into a neat package that makes creating simple apps that respond to webhooks a pleasure.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'webhook_handler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install webhook_handler

## Usage

Define a class and include the `WebhookHandler` module. This class then acts as a Sidekiq worker and a Rack app.

**app.rb**

```ruby
require 'webhook_handler'

class MyApp
  include WebhookHandler

  def perform
    puts "Working hard!"
    sleep 5
  end
end
```

**config.ru**

```ruby
require_relative './app'
run MyApp
```

If you want to pass some arguments from the request into the background job you can define a `handle_webhook` method.

```ruby
class MyApp
  include WebhookHandler

  def handle_webhook
    request.body.rewind
    payload = JSON.parse(request.body.read)
    self.class.perform_async(payload['message'])
  end

  def perform(message)
    puts "Got a message: #{message}"
    # Do some long running task...
    sleep 2
  end
end
```

## CLI

You can also generate a new app with the command line tool:

    $ webhook_handler new acme_widget_receiver

This will generate a new app in the `acme_widget_receiver` directory with the class `AcmeWidgetReceiver` in the `app.rb` file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chrismytton/webhook_handler.
