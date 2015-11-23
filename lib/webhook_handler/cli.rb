require 'thor'
require 'fileutils'
require 'webhook_handler/version'

module WebhookHandler
  class CLI < Thor
    include Thor::Actions
    desc "new NAME", "create a new app called NAME"

    def self.source_root
      File.dirname(__FILE__)
    end

    def new(name)
      # @see http://git.io/vBqrp
      @constant_name = name.tr('-', '_').gsub(/-[_-]*(?![_-]|$)/) { "::" }.gsub(/([_-]+|(::)|^)(.|$)/) { $2.to_s + $3.upcase }

      FileUtils.mkdir_p(name)
      puts "Creating app '#{name}'..."
      templates = {
        'Gemfile.tt' => 'Gemfile',
        'Procfile' => 'Procfile',
        'app.rb.tt' => 'app.rb',
        'config.ru.tt' => 'config.ru'
      }

      templates.each do |src, dest|
        template(File.join('templates', src), File.join(name, dest))
      end
    end
  end
end
