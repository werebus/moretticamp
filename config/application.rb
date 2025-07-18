require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Moretticamp
  class Application < Rails::Application
    require 'oauth_provider'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    config.before_initialize do
      OauthProvider.new :google_oauth2, 'Google', 'google',
                        Rails.application.credentials.google&.fetch(:client_id, nil),
                        Rails.application.credentials.google&.fetch(:client_secret, nil)
    end

    config.middleware.use Rack::Attack
    config.time_zone = 'America/New_York'

    mail_previews = Rails.root.join('app/mailers/previews')
    config.action_mailer.preview_paths << mail_previews
    config.eager_load_paths << mail_previews

    config.poetry = config_for(:poetry)
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    # config.autoload_lib(ignore: %w[assets tasks])
  end
end
