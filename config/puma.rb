# frozen_string_literal: true

# Puma can serve each request in a thread from an internal thread pool.
# The `threads` method setting takes two numbers: a minimum and maximum.
# Any libraries that use thread pools should be configured to match
# the maximum value specified for Puma. Default is set to 5 threads for minimum
# and maximum; this matches the default thread size of Active Record.
#
rails_env = ENV.fetch('RAILS_ENV') { 'development' }
max_threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
min_threads_count = ENV.fetch('RAILS_MIN_THREADS') { max_threads_count }
app_dir = File.expand_path('..', __dir__)

threads min_threads_count, max_threads_count
workers ENV.fetch('WEB_CONCURRENCY') { 2 }

# Specifies the `worker_timeout` threshold that Puma will use to wait before
# terminating a worker in development environments.
#
worker_timeout 3600 if rails_env == 'development'

environment rails_env

wait_for_less_busy_worker

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

if %w(staging production).member?(rails_env)
  bind "unix://#{app_dir}/tmp/sockets/bpldc_auth_puma.sock"
  stdout_redirect("#{app_dir}/log/puma.stdout.log", "#{app_dir}/log/puma.stderr.log", true)
  pidfile "#{app_dir}/tmp/pids/bpldc_puma_server.pid"
  state_path "#{app_dir}/tmp/pids/bpldc_puma_server.state"
else
  port ENV.fetch('PORT') { 3000 }
  stdout_redirect('/dev/stdout', '/dev/stderr')
  pidfile "#{app_dir}/tmp/pids/server.pid"
  state_path "#{app_dir}/tmp/pids/server.state"
  plugin :tmp_restart
end
