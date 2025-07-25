require_relative "boot"
require 'logger'
require "rails/all"
require 'jwt'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module QuestifyApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.logger = Logger.new(STDOUT) if Rails.env.development?
    config.autoload_paths << Rails.root.join("exceptions")
    config.autoload_paths << Rails.root.join("lib")

    config.hosts << "http://localhost:3000"
    config.hosts << "http://127.0.0.1:3000"

    config.hosts << "http://localhost:3000"
    config.hosts << "http://127.0.0.1:3000"

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
  end
end
