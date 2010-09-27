class BookingsController < ApplicationController
  layout nil

  # GET /bookings/1
  # GET /bookings/1.xml
  def show
    @booking = Booking.find(params[:id])

    church = ( @booking.church_id? ) ? Church.find_by_id(@booking.church_id) : nil
    booking = {
      'website'          => @booking.deputation.missionary.website || '',
      'last-modified'    => @booking.updated_at.strftime('%Y%m%d'),
      'status'           => @booking.status,
      'date'             => @booking.date_of.strftime('%Y%m%d'),
      'time'             => (@booking.time_of) ? @booking.time_of.strftime('%l:%M %P') : nil,
      'email'            => @booking.deputation.missionary.email || '',
      'outreach'         => church.outreach_cities || '',
      'church_address'   => church.physical_address || church.mailing_address || '',
      'church_name'      => church.church_name || '',
      'pastor'           => church.pastor || '',
      'fm_deputation_id' => @booking.deputation_id,
      'poster'           => @booking.deputation.missionary.poster || '',
      'labor'            => @booking.deputation.missionary.labor,
      'church_id'        => @booking.church_id,
      'name'             => @booking.deputation.missionary.name,
      'phone'            => @booking.deputation.missionary.phone,
      'church_phone'     => church.phone || '',
      'book_id'          => @booking.id,
      'church_city'      => church.physical_city || church.mailing_city,
      'meridian'         => @booking.meridian,
    }

    respond_to do |format|
      format.xml { render :xml  => booking }
      format.js  { render :json => booking.to_json }
    end 
    
  end

end




