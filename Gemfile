# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 3.1.6'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 5.6'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# Needed for caching
gem 'connection_pool', '~> 2.4'
gem 'jbuilder', '~> 2.11'
gem 'redis', '~> 4.8'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'geomash', github: 'samvera-labs/geomash', ref: '4e9213a'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '~> 1.1'

gem 'oj', '~> 3.15'
gem 'psych', '~> 3.3'

# Required gems for QA and linked data access
gem 'linkeddata', '~> 3.2'
# NOTE: Geomash needs to be updated to updated to handle the breaking changes in
gem 'qa', '~> 5.10'

gem 'faraday', '~> 1.10', '< 2'
gem 'faraday_middleware', '~> 1.2'

gem 'sd_notify', group: [:production, :staging]

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :development, :test do
  gem 'awesome_print', '~> 1.9'
  gem 'capistrano', '~> 3.17.1', require: false
  gem 'capistrano3-puma'
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-rvm'
  gem 'dotenv-rails', '~> 2.8'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'faker', '~> 2.23'
  gem 'pry', '~> 0.13.1'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 5.1'
  gem 'rubocop', '~> 1.36', require: false
  gem 'rubocop-performance', '~> 1.15', require: false
  gem 'rubocop-rails', '~> 2.16', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'coveralls_reborn', require: false
  gem 'database_cleaner-active_record', '~> 2'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'shoulda-matchers', '~> 5.2'
  gem 'simplecov', '~> 0.22'
  gem 'vcr', '~> 6.1'
  gem 'webmock', '~> 3.18'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
