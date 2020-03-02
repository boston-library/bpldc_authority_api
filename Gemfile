# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.4', '>= 5.2.4.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Required gems for QA and linked data access
gem 'qa', '~> 5.3'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :development, :test do
  gem 'awesome_print', '~> 1.8.0'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails', '~> 2.7'
  gem 'factory_bot_rails', '~> 5.0'
  gem 'faker', '~> 2.6.0'
  gem 'pry', '~> 0.12.2'
  gem 'pry-byebug', '~> 3.7.0'
  gem 'pry-rails', '~> 0.3.9'
  gem 'rubocop', '~> 0.75.0', require: false
  gem 'rubocop-performance', '~> 1.5.0', require: false
  gem 'rubocop-rails', '~> 2.3.2', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'coveralls', require: false
  gem 'database_cleaner', '~> 1.8'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.9'
  gem 'shoulda-matchers', '~> 4.1'
  gem 'vcr', '~> 5.1.0'
  gem 'webmock', '~> 3.7.6'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
