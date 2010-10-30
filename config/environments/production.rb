# Settings specified here will take precedence over those in config/environment.rb

config.cache_classes = true

cronolog_io = IO.popen( '/usr/bin/cronolog /web/logs/waupc-radiant/rails.%Y%m%d','w' )
config.logger = Logger.new(cronolog_io)
config.logger.level = Logger::WARN

# Full error reports are disabled and caching is on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors if you bad email addresses should just be ignored
# config.action_mailer.raise_delivery_errors = false
