rails_env = ENV['RAILS_ENV'] || 'development'
worker_processes 2
listen 3100

preload_app true

if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

stderr_path "/web/logs/waupc-radiant/unicorn.stderr.log"
stdout_path "/web/logs/waupc-radiant/unicorn.stdout.log"

before_fork do |server,worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server,worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
