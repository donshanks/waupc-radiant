class DeputationsController < ApplicationController
  layout nil

  # GET /deputations
  # GET /deputations.xml
  def index
    
    if params[:conditions]
      @deputations = Deputation.find(:all, 
        :conditions => params[:conditions],
        :order => 'date_start ASC',
        :limit => params[:l]|| 100
      )
    else
      @deputations = Deputation.find(:all, 
        :conditions => 'date_end >= CURRENT_DATE',
        :order => 'date_start ASC',
        :limit => params[:l] || 100
      )
    end

	  js_deputations = []

    for deputation in @deputations
      js_deputation = {
        'ID'               => 'FM'+deputation.id.to_s,
        'website'          => deputation.missionary.website || "",
        'email'            => deputation.missionary.email   || "",
        'labor'            => deputation.missionary.labor,
        'poster'           => deputation.missionary.poster  || "",
        'accomodations'    => deputation.accomodations      || "",
        'method-of-travel' => deputation.method_of_travel   || "",
        'name'             => deputation.missionary.name,
        'status'           => deputation.status,
        'number-in-party'  => deputation.number_in_party,
        'last-modified'    => deputation.updated_at.strftime('%Y%m%d'),
        'start-date'       => deputation.date_start.strftime('%Y%m%d'),
        'end-date'         => deputation.date_end.strftime('%Y%m%d'),
        'phone'            => deputation.missionary.phone   || "",
        'bookings'         => []
      }
      for booking in deputation.bookings
        js_booking = {
          'date'   => booking.date_of.strftime('%Y%m%d'),
          'time'   => (booking.time_of) ? booking.time_of.strftime('%l:%M %P') : nil,
          'status' => booking.status,
          'id'     => booking.id
        }
        if booking.church_id && booking.church_id > 0
          church = Church.find_by_id(booking.church_id)
          js_booking.store('church',{
            'city'    => church.physical_city || "",
            'pastor'  => church.pastor,
            'name'    => church.church_name,
            'address' => church.physical_address || church.mailing_address || "",
            'phone'   => church.phone,
            'id'      => church.id
          })
        end
        js_deputation['bookings'].push(js_booking)
      end
      js_deputations.push(js_deputation)
    end

    respond_to do |format|
      format.xml  { render :xml  => js_deputations.to_xml }
      format.js   {
        if !params[:t].nil? then
          #headers['Content-Type'] = 'text/javascript'
          render :template => "deputations/#{params[:t]}", :layout => nil
        else 
          render :json => js_deputations.to_json 
        end
      }
	  end

  end

  def foreign_missions
      @deputations = Deputation.find(:all, 
        :conditions => 'date_end >= CURRENT_DATE',
        :order => 'date_start ASC'
      )
  end

end

