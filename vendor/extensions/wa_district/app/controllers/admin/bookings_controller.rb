class Admin::BookingsController < ApplicationController
  layout "admin"

  # GET /bookings
  def index
    @bookings = Booking.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /bookings/1
  def show
    @booking = Booking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js do
        church = ( @booking.church_id? ) ? Church.find_by_id(@booking.church_id) : nil
        js_booking = {
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
        render :json => js_booking.to_json
      end
    end
  end

  # GET /bookings/new
  def new
    @booking = Booking.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /bookings/notify/1
  def notify
    @booking = Booking.find(params[:id])

    date_time = @booking.date_of.strftime('%A, %B %e at ')
    date_time << @booking.time_of.strftime('%l:%M %P')
    church = Church.find_by_id(@booking.church_id)

    PostOffice.deliver_confirmation_notice(
      @booking.deputation.missionary.name,
      church.pastor,
      church.church_name,
      date_time,
      church.minister.email
    )

    render :json => "Success".to_json
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
  end

  # POST /bookings
  def create
    @booking = Booking.new(params[:booking])

    respond_to do |format|
      if @booking.save
        flash[:notice] = 'Booking was successfully created.'
        format.html { redirect_to(@booking) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /bookings/1
  def update
    @booking = Booking.find(params[:id])

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
        format.html do 
			    render :update do |page|
        		flash[:notice] = 'Booking was successfully updated.'
				    redirect_to(@booking)
			    end
		    end
		    format.js do
			    render :json => { :id => params[:id], :success => true, :status => @booking.status }.to_json
		    end
      else
        format.html { render :action => "edit" }
		    format.js do
			    render :json => { :id => params[:id], :success => false, :status => @booking.status }.to_json
	      end
	    end
    end
  end

  # DELETE /bookings/1
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to(bookings_url) }
    end
  end
end

