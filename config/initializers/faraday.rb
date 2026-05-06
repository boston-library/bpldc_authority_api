# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'

Faraday.default_connection = Faraday.new do |conn|
  # Add the redirect middleware to the global default stack
  conn.use FaradayMiddleware::FollowRedirects, limit: 3

  # Standard defaults usually included in a Faraday stack
  conn.request :url_encoded
  conn.adapter Faraday.default_adapter
end