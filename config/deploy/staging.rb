# server-based syntax
# ======================

# Grab ruby version from project home directory. It is needed for deployment.

set :rvm_ruby_version, File.read(File.expand_path('./../../.ruby-version', __dir__)).strip

# set :branch, 'jenkins'
set :branch, 'capistrano'

# role-based syntax
# ==================

# Defines a role with one or multiple servers. The primary server in each
# group is considered to be the first unless any hosts have the primary
# property set. Specify the username and a domain or IP for the server.
# Don't use `:all`, it's a meta role.

role :app, %w{manager@172.29.101.160}
role :web, %w{manager@172.29.101.160}
role :db,  %w{manager@172.29.101.160}


## When Capistrano tries to delete old release, puma socket/id can be removed only by sudo user.
## Allow current user to run it with sudo priviledge.
SSHKit.config.command_map[:rm] = 'sudo rm'

# Custom SSH Options
# SSH to remote server uses username/password.
# For security reason, here uses ssh key.
server '172.29.101.160', {
  :user => 'manager',
  :role => %w{app db web},
  :ssh_options => {
    :keys =>  '/var/lib/jenkins/.ssh/promdev'
  }
}


