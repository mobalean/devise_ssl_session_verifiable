ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)

require "rails_app/config/environment"
require "rails/test_help"

#ActiveRecord::Migration.verbose = false
#ActiveRecord::Base.logger = Logger.new(nil)
ActiveRecord::Migrator.migrate(File.expand_path("../rails_app/db/migrate/", __FILE__))

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

require 'webrat'
Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

# Add support to load paths so we can overwrite broken webrat setup
$:.unshift File.expand_path('../support', __FILE__)
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

