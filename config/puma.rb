environment ENV.fetch('RACK_ENV', 'development')

port ENV.fetch('PORT', 9292)

# Enable auto-reloading in development
if ENV['RACK_ENV'] == 'development'
  require 'puma/plugin/tmp_restart'
  plugin :tmp_restart
end

# Enable multiple workers in production
if ENV['RACK_ENV'] == 'production'
  workers ENV.fetch('WEB_CONCURRENCY', 2)
  threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
  threads threads_count, threads_count
end
