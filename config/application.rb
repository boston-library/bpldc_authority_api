# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
# require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BpldcAuthorityApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.api_only = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.

    config.generators do |g|
      g.orm :active_record
      g.api_only = true
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end

    # NOTE Geomash doesn't read ERB/ENV in config/geomash.yml, so we reset it here
    Geomash.config[:geonames_username] = ENV.fetch('GEONAMES_USERNAME') { Rails.application.secrets.dig(:geonames_user) }
    Geomash.config[:google_key] = ENV.fetch('GOOGLE_MAPS_API_KEY') { Rails.application.secrets.dig(:google_maps_api_key) }

    Qa::Authorities::Geonames.username = ENV.fetch('GEONAMES_USERNAME') { Rails.application.secrets.dig(:geonames_user) }
  end
end
