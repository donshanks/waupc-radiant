require 'pp'
require 'pay_pal_notification'

class IpnController < ApplicationController
  no_login_required
  skip_before_filter :verify_authenticity_token 
  
  def log

    notify = PayPalNotification.new(params)

    ipnlog = File.new( File.join("/web/logs/waupc-radiant","ipnlog.#{Time.now.strftime('%Y%m%d')}"), 'a' )
    ipnlog.write("#{params.to_json}\n")
    ipnlog.close

    if notify.acknowledge
      begin
        entry = IpnLogEntry.create( notify.log_entry )
      end
    else
    end


    render :nothing => true
  end

end
