# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class LookupExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/lookup"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :lookup
  #   end
  # end
  
  def activate
    Page.send :include, LookupTags
    # admin.tabs.add "Lookup", "/admin/lookup", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Lookup"
  end
  
end
