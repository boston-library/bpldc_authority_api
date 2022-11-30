# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"


set :application, "bpldc_authority_api"
set :repo_url, "https://github.com/boston-library/bpldc_authority_api.git"
set :rails_env, 'staging'
set :rvm_ruby_version, File.read(File.expand_path('./../.ruby-version', __dir__)).strip

set :deploy_to, "/home/manager/bpldc_authority_api"

set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

## When running tasks against staging server, some tasks defined in it needs to be available.
## config/deploy/staging.rb cannot be removed from <project>/shared/ directory, because it is temporarily not forcibly using ssl.
## Otherwise curl 172.29.101.160 returns 301....
append :linked_files, "config/database.yml", "config/staging.key", "config/credentials/staging.key", "config/environments/staging.rb"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets"

set :default_env, { node_env: :staging }

# Default value for keep_releases is 5
set :keep_releases, 5

# Costomized tasks that restart our services
namespace :boston_library do
    desc "Greeting from BOSTON PUBLIC LIBRARY"
    task :hello do
        on roles(:app, :db) do
          execute('echo Hello BOSTON PUBLIC LIBRARY')
        end
    end

    ## rvm_ruby_version = 3.0.4
    desc "gem update"
    task :gem_update do
      on roles(:app) do
        execute("/home/manager/.rvm/bin/rvm #{fetch(:rvm_ruby_version)} do gem update --system --no-document")
      end
    end


    desc "bpldc_authority_api restart bpldc_puma service"
    task :restart_bpldc_nginx do
      on roles(:app), in: :sequence, wait: 5 do
        # execute 'sudo /bin/systemctl restart current_bpldc_puma.socket current_bpldc_puma.service'
        execute 'sudo /bin/systemctl restart bpldc_puma.socket bpldc_puma.service'
        sleep(5)
      end
    end

    desc "Capistrano restarts nginx services"
    task :restart_nginx do
	    on roles(:app), in: :sequence, wait: 5 do
	      execute 'sudo /bin/systemctl restart nginx.service'
	    end
	  end

end

before :'bundler:install', :'boston_library:gem_update'
before :'deploy:migrate', :'boston_library:hello'
after 'deploy:cleanup', 'boston_library:restart_bpldc_nginx'
after 'boston_library:restart_bpldc_nginx', 'boston_library:restart_nginx'

