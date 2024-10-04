# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  Geomash.class_eval do
    def self.config
      @config ||= YAML.load(File.open(config_path), aliases: true)[env]
                    .with_indifferent_access
    end
  end

  # NOTE: Geomash doesn't read ERB/ENV in config/geomash.yml, so we reset it here
  Geomash.config[:geonames_username] = ENV.fetch('GEONAMES_USERNAME') { Rails.application.credentials.dig(:geonames_user) }
  Geomash.config[:google_key] = ENV.fetch('GOOGLE_MAPS_API_KEY') { Rails.application.credentials.dig(:google_maps_api_key) }

  Qa::Authorities::Geonames.username = ENV.fetch('GEONAMES_USERNAME') { Rails.application.credentials.dig(:geonames_user) }
end