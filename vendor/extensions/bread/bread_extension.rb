# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class BreadExtension < Radiant::Extension
  version "1.0"
  description "Bible Reading Enriches Any Day"
  url "http://waupc.com/ws"
  
  define_routes do |map|
    map.connect   '/ws/bread.php', :controller => 'bread'
    map.connect   'bread', :controller => 'bread'
    map.connect   'bread/:year/:month/:day', 
                  :controller => 'bread', 
                  :action     => 'lookup_by_date',
                  :year       => /\d{4}/,
                  :month      => /\d{1,2}/,
                  :day        => /\d{1,2}/
  end
  
  def activate
    # admin.tabs.add "Bread", "/admin/bread", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Bread"
  end
  
end
