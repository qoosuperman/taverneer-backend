# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

require_relative '../lib/authentication/password_strategy'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TaverneerBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

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
    config.i18n.default_locale = 'zh-TW'

    config.session_store :cookie_store, key: '_taverneer_sesson', expire_after: 1.day
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
    config.middleware.use Warden::Manager do |manager|
      manager.default_strategies :password
      # 之後行為變複雜的話，可以考慮學 devise 替換成 callable object
      # ref: https://github.com/heartcombo/devise/blob/main/lib/devise/failure_app.rb
      manager.failure_app = proc { |_env|
        ['401', { 'Content-Type' => 'application/json' }, { message: 'Unauthorized', status: 'unauthorized' }.to_json]
      }
    end
  end
end
