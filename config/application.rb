require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DpsstMagnifier
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Allow our service objects to be autoloaded
    config.autoload_paths << Rails.root.join("lib")
    config.autoload_paths << Rails.root.join("services")

    # Allow our service objects to be eagerloaded
    config.eager_load_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("services")

    config.logger = Logger.new(STDOUT)
  end
end
