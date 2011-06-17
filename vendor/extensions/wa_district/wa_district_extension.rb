# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application_controller'

class WaDistrictExtension < Radiant::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://waupc.com/foreign-missions"
  
  # define_routes do |map|
  #   map.namespace :admin, :member => { :remove => :get } do |admin|
  #     admin.resources :foreign_missions
  #   end
  # end
 
  define_routes do |map|
    map.with_options :controller => 'reservations', :path_prefix => '/foreign-missions' do |fm|
      fm.connect            '/',                          :action => 'index'
      fm.show_reservations  'reservations',               :action => 'index'
      fm.show_deputation    'reservations/:dep_id',       :action => 'show' 
      fm.book_reservation   'reservations/book/:book_id', :action => 'book' 
      fm.update_reservation 'reservation/update',         :action => 'update'
    end
    map.connect '/ipn/:prod_id', :controller => 'ipn', :action => 'log'
  end

  def activate
    # admin.tabs.add "Foreign Missions", "/admin/foreign_missions", :after => "Layouts", :visibility => [:all]
  end
  
  def deactivate
    # admin.tabs.remove "Foreign Missions"
  end
  
end
