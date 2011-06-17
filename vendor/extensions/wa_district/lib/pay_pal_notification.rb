require 'net/https'
require 'uri'

class PayPalNotification

  attr_accessor :paypal_url

  def initialize(params)
    @ipn=params
    self.paypal_url = (@ipn['test_ipn'] == "1") ? 'https://www.sandbox.paypal.com' : 'https://www.paypal.com'
  end

  def complete?
    status == 'Completed'
  end

  def received_at
    Time.parse @ipn['payment_date']
  end

  def custom
    @ipn['custom']
  end

  def status
    @ipn['payment_status']
  end

  def transaction_id
    @ipn['txn_id']
  end

  def acknowledge
    unless RAILS_ENV=='test'
      payload = @ipn

      uri = URI.parse(self.paypal_url)
      http = Net::HTTP.new(uri.host,uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      uri.merge!( "/cgi-bin/webscr?cmd=_notify-validate&#{@ipn.to_query}" )

      request = Net::HTTP::Get.new(uri.request_uri)

      response = http.request(request)

      raise StandardError.new("Faulty paypal result: #{response.body}") unless ["VERIFIED","INVALID"].include?(response.body)

      response.body == 'VERIFIED'
    end
  end

  def log_entry
    e = {
      :prod_id        => @ipn['prod_id'],
      :txn_id         => @ipn['txn_id'],
      :payer_email    => @ipn['payer_email'],
      :payer_id       => @ipn['payer_id'],
      :first_name     => @ipn['first_name'],
      :last_name      => @ipn['last_name'],
      :address_name   => @ipn['address_name'],
      :address_street => @ipn['address_street'],
      :address_city   => @ipn['address_city'],
      :address_state  => @ipn['address_state'],
      :address_zip    => @ipn['address_zip'],
      :payment_fee    => @ipn['mc_fee'],
      :payment_gross  => @ipn['mc_gross'],
      :payment_date   => @ipn['payment_date'],
      :payment_status => @ipn['payment_status'],
      :raw_response   => @ipn.to_json,
    }

    quantity_keys    = @ipn.keys.grep(/quantity/).sort 
    item_name_keys   = @ipn.keys.grep(/item_name/).sort 
    item_number_keys = @ipn.keys.grep(/item_number/).sort 

    e[:quantities]   = quantity_keys.collect {|k| @ipn[k]}.join(',')
    e[:item_names]   = item_name_keys.collect {|k| @ipn[k]}.join(',')
    e[:item_numbers] = item_number_keys.collect {|k| @ipn[k]}.join(',')

    return e
  end

end
