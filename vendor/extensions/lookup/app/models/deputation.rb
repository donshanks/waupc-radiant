class Deputation < ActiveRecord::Base
  establish_connection "waupc_production"
	belongs_to :missionary
	has_many :bookings

	@bookings = nil

	def date_range
		if ( date_start.mon == date_end.mon )
			return date_start.strftime('%b ') + date_start.day().to_s() + "-" + date_end.day().to_s() + " " + date_start.year().to_s()
		else 
			return date_start.strftime('%b ') + date_start.day().to_s() + " - " + date_end.strftime('%b ') + date_end.day().to_s() + " " + date_start.year().to_s()
		end
	end

  def bookings_available
    Booking.find(:all, :conditions => ['deputation_id = ? AND status = ?', id, 'open'])
  end

	def bookings
		Booking.find(:all, :conditions => ['deputation_id = ?',id])
	end

  def safe_id
    "FM#{id}"
  end
	
end
