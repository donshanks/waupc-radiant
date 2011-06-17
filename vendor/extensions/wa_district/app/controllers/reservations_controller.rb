require 'date'

class ReservationsController < ApplicationController
  radiant_layout "default-page"
  no_login_required
  
  def index
    @deputations = Deputation.find(:all, 
      :conditions => %(date_end >= CURRENT_DATE and status = 'active'),
      :order      => 'date_start ASC',
      :limit      => params[:l] || 20
    )
  end

  def show
    unless params[:dep_id].blank? then
      @deputation = Deputation.find(params[:dep_id])
    end
  end

  def book
    @booking = Booking.find(params[:book_id])
		@churches = Church.find_all_by_status('active')
  end

  def update
    if params[:uname] != 'waupc' or params[:pwd] != 'vision' then
      flash[:notice] = "Invalid Username or Password"
      redirect_to book_reservation_path(params[:booking][:id])
      return
    end

    unless params[:booking][:church_id].to_i > 0
      flash[:notice] = "A church must be selected"
      redirect_to book_reservation_path(params[:booking][:id])
      return
    end

    if !params[:booking][:email].empty? and !valid_email?(params[:booking][:email])
      flash[:notice] = "Invalid email address"
      redirect_to book_reservation_path(params[:booking][:id])
      return
    end

    @booking = Booking.find(params[:booking][:id])

    @booking.status = 'booked'
    @booking.notes  = params[:booking][:notes] unless params[:booking][:notes].empty?  
    @booking.email  = params[:booking][:email] unless params[:booking][:email].empty?
    @booking.church_id = params[:booking][:church_id].to_i
    @booking.time_of   = params[:booking]["time_of(5i)"]

    begin
      @booking.save!
    rescue Exception => err
      flash[:notice] = err.message
      redirect_to book_reservation_path(params[:booking][:id])
      return
    end

    send_notice(params[:booking][:email])
    return

  end

  private
  def valid_email?(str)
    return !str.match(/^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i).nil?
  end

  def send_notice(to)
    date_time = @booking.date_of.strftime('%A, %B %e at ')
    date_time << @booking.time_of.strftime('%l:%M %P')
    church = Church.find_by_id(@booking.church_id)

    PostOffice.deliver_confirmation_notice(
      @booking.deputation.missionary.name,
      church.pastor,
      church.church_name,
      date_time,
      to
    )
  end

end
