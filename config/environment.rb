RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

require 'radius'

Radiant::Initializer.run do |config|
  # config.frameworks -= [ :action_mailer ]

  config.action_controller.session = {
    :session_key => '_waupc-radiant_session',
    :secret      => '3f3e9b190c8ecbff1ac9df17d9d059ed6a800285'
  }

  config.middleware.use ::Radiant::Cache
  config.action_controller.session_store = :cookie_store
  config.active_record.observers = :user_action_observer
  config.time_zone = 'UTC'

  config.gem "sanitize"
  config.gem "newrelic_rpm"

  config.action_view.field_error_proc = Proc.new do |html, instance|
    if html !~ /label/
      %{<div class="error-with-field">#{html} <small class="error">&bull; #{[instance.error_message].flatten.first}</small></div>}
    else
      html
    end
  end

  config.after_initialize do
    # Add new inflection rules using the following format:
    ActiveSupport::Inflector.inflections do |inflect|
      inflect.uncountable 'config'
    end
    Radiant::Config['admin.title'] = "Washington District UPCI"
    Radiant::Config['admin.subtitle'] = "Bringing the Gospel to Washington State"
    Radiant::Config['defaults.page.parts'] = "body,sidebar"
    Radiant::Config['defaults.page.filter'] = "Fckeditor"

    Radiant::Config['comments.simple_spam_filter_required?'] = false
    Radiant::Config['comments.mollom_privatekey'] = "4a57fcc4aaa06118a36fc3790498b88d"
    Radiant::Config['comments.mollom_publickey'] = "f246f89c5c551ff7140195c50912a5e1"
  end
end
