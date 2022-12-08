# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.17.1'
require File.expand_path('./environment', __dir__)

set :application, 'bpldc_authority_api'
set :repo_url, "https://github.com/boston-library/#{fetch(:application)}.git"
set :deploy_to, "/home/manager/#{fetch(:application)}"

set :rvm_installed, '/home/manager/.rvm/bin/rvm'
set :rvm_ruby_version, File.read(File.expand_path('./../.ruby-version', __dir__)).strip
set :rvm_bundle_version, File.read(File.expand_path('./Gemfile.lock'))[-10..-1].strip
## Gemfile.lock show puma version as "    puma (5.6.5) " -  don't remove space from "/ /"
set :rvm_puma_version, File.readlines('./Gemfile.lock').reverse.find { |v| v =~ /    puma/ }[-7..-3]

# Default value for :pty is false
set :pty, true

## When running tasks against staging server, some tasks defined in it needs to be available.
## config/deploy/staging.rb cannot be removed from <project>/shared/ directory, because it is temporarily not forcibly using ssl.
## Otherwise "curl server_IP" returns 301....
append :linked_files, 'config/database.yml', 'config/credentials/staging.key', 'config/environments/staging.rb'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'bundle'

# Default value for keep_releases is 5
set :keep_releases, 5

# Costomized tasks that restart our services
namespace :boston_library do
  desc 'Gem update'
  task :gem_update do
    on roles(:app) do
      execute("#{fetch(:rvm_installed)} #{fetch(:rvm_ruby_version)} do gem update --system --no-document")
    end
  end

  desc 'Install new ruby if ruby-version is required'
  task :rvm_install_ruby do
    on roles(:app) do
      execute("#{fetch(:rvm_installed)} install #{fetch(:rvm_ruby_version)} -C --with-jemalloc")
      execute("#{fetch(:rvm_installed)} use #{fetch(:rvm_ruby_version)}")
    end
  end

  # desc 'Install bundler 2.3.26 and puma 5.6.5'
  desc "Install bundler #{fetch(:rvm_bundle_version)}"
  task :install_bundler do
    on roles(:app) do
      execute("#{fetch(:rvm_installed)} #{fetch(:rvm_ruby_version)} do gem install bundler:#{fetch(:rvm_bundle_version)}")
      execute("#{fetch(:rvm_installed)} #{fetch(:rvm_ruby_version)} do gem install puma:#{fetch(:rvm_puma_version)}")
    end
  end

  desc 'bpldc_authority_api restart bpldc_puma service'
  task :restart_bpldc_nginx do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'sudo /bin/systemctl restart bpldc_puma.service'
      sleep(5)
    end
  end

  desc 'Capistrano restarts nginx services'
  task :restart_nginx do
    on roles(:app), in: :sequence, wait: 5 do
      execute 'sudo /bin/systemctl restart nginx.service'
    end
  end
end

before :'rvm:check', :'boston_library:rvm_install_ruby'
after :'boston_library:gem_update', :'install_bundler'
before :'bundler:install', :'boston_library:gem_update'
after 'deploy:cleanup', 'boston_library:restart_bpldc_nginx'
after 'boston_library:restart_bpldc_nginx', 'boston_library:restart_nginx'