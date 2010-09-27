class Booking < ActiveRecord::Base
	belongs_to :deputation
  belongs_to :church

  validates_format_of :email, 
    :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  def select_formatted_date_of
    ext = %w(th st nd rd th th th th th th) [date_of.day % 10]
    return date_of.strftime("%A, %B %e#{ext}, %Y (#{meridian})")
  end

  def time
    return nil if time_of.blank?
    time_of.strftime('%l:%M %P')
  end

  def date
    date_of.strftime('%Y%m%d')
  end

end
