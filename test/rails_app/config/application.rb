require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"

Bundler.require :default

begin
  require "active_record/railtie"
rescue LoadError
end

require "devise"

module RailsApp
  class Application < Rails::Application
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters << :password
    config.assets.enabled = false
    config.action_mailer.default_url_options = { :host => "localhost:3000" }

    # This was used to break devise in some situations
    config.to_prepare do
      Devise::SessionsController.layout "application"
    end
  end
end
