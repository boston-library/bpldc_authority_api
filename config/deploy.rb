# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

# set :application, "my_app_name"
# set :repo_url, "git@example.com:me/my_repo.git"
set :application, "bpldc_authority_api"
set :repo_url, "https://github.com/boston-library/bpldc_authority_api.git"
set :rails_env, 'staging'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, "/home/manager/bpldc_authority_api"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", 'config/master.key'
# append :linked_files, "config/database.yml", "config/staging.key", 


## When running tasks against staging server, some tasks defined in it needs to be available.
## config/deploy/staging.rb cannot be removed from <project>/shared/ directory. 
append :linked_files, "config/database.yml", "config/staging.key", "config/credentials/staging.key", "config/environments/staging.rb"
# append :linked_files, "config/database.yml", "config/staging.key", "config/credentials/staging.key"

## , "lib/capistrano/tasks/bpldc_nginx.rake"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "vendor", "storage"
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "tmp/webpacker", "public/system", "public/packs", "node_modules", "bundle", "vendor", "storage"

append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { node_env: :staging }


# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
namespace :boston_library do
    desc "Greeting from BOSTON PUBLIC LIBRARY"
    task :hello do
        on roles(:app, :db) do
          execute('echo Hello BOSTON PUBLIC LIBRARY')
        end
    end

    desc "gem update"
    task :gem_update do
      on roles(:app) do
        execute('~/.rvm/bin/rvm 3.0.4 do gem update --system --no-document')
        # execute('gem update --no-document')
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

# before 'boston_library:staging_key_symlink', 'boston_library:restart_bpldc_nginx'
after 'deploy:cleanup', 'boston_library:restart_bpldc_nginx'
after 'boston_library:restart_bpldc_nginx', 'boston_library:restart_nginx'

