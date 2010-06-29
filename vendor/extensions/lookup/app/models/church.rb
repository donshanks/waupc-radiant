class Church < ActiveRecord::Base
  establish_connection "waupc_production"
  belongs_to :minister
  attr_accessor :lat1, :lon1, :distance, :googlelink

	def selector_name
		"#{church_name} , #{physical_city} (#{pastor})"
	end

  def full_physical_address
    "#{physical_address}, #{physical_city}  #{physical_zip}"
  end

  def full_mailing_address
    "#{mailing_address}, #{mailing_city}  #{mailing_zip}"
  end

  def minister
    Minister.find(:first, :conditions => ['id = ?',minister_id])
  end

  def address 
    return physical_address unless physical_address.blank?
    return mailing_address unless mailing_address.blank?
    return ""
  end
  def city 
    return physical_city unless physical_city.blank?
    return mailing_city unless mailing_city.blank?
    return ""
  end


end
