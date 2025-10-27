# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.10'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.1.5'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 6.6'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Needed for caching
gem 'connection_pool', '~> 2.5'
gem 'csv'
gem 'jbuilder', '~> 2.11'
gem 'redis', '~> 5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'geomash', github: 'samvera-labs/geomash', ref: '4e9213a'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 2.0'

gem 'oj', '~> 3.16'
# Required gems for QA and linked data access
gem 'linkeddata', '~> 3.2'
# NOTE: Geomash needs to be updated to updated to handle the breaking changes in
gem 'qa', '~> 5.15'

gem 'faraday', '~> 1.10', '< 2'
gem 'faraday_middleware', '~> 1.2'

group :development do
  gem 'listen'
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
end

group :development, :test do
  gem 'capistrano', '~> 3.19.2', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm'
  gem 'debug', platforms: %i(mri windows)
  gem 'dotenv-rails', '~> 2.8'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 3.2'
  gem 'rspec-rails', '~> 7.1'
  gem 'rubocop', '~> 1.36', require: false
  gem 'rubocop-performance', '~> 1.15', require: false
  gem 'rubocop-rails', '~> 2.16', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'coveralls_reborn', require: false
  gem 'database_cleaner-active_record', '~> 2.2'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'shoulda-matchers', '~> 6.4'
  gem 'simplecov', '~> 0.22'
  gem 'vcr', '~> 6.3'
  gem 'webmock', '~> 3.23'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:windows, :jruby]
