class Admin::DeputationsController < ApplicationController
  layout 'fhview'
  before_filter :login_required

  # GET /deputations
  def index

    @admin_menu = true

    if params[:conditions]
      @deputations = Deputation.find(:all, 
        :conditions => params[:conditions],
        :order => 'date_start ASC'
      )
    else
      @deputations = Deputation.find(:all, 
        :conditions => 'date_end >= CURRENT_DATE',
        :order => 'date_start ASC'
      )
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /deputations/1
  def show
    @deputation = Deputation.find(params[:id])
		@churches = Church.find(:all, :conditions => "status = 'active'", :order => 'church_name ASC')

    @admin_menu = true

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /deputations/new
  def new
    @deputation = Deputation.new
	@mid = params[:mid]

    @admin_menu = true

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /deputations/1/edit
  def edit
    @deputation = Deputation.find(params[:id])

    @admin_menu = true

  end

  # POST /deputations
  def create
    @deputation = Deputation.new(params[:deputation])

    @admin_menu = true

    respond_to do |format|
      if @deputation.save

		start_date = Date.new(params[:deputation][:"date_start(1i)"].to_i,
							  params[:deputation][:"date_start(2i)"].to_i,
							  params[:deputation][:"date_start(3i)"].to_i)

		end_date = Date.new(params[:deputation][:"date_end(1i)"].to_i,
							params[:deputation][:"date_end(2i)"].to_i, 
							params[:deputation][:"date_end(3i)"].to_i)

		(start_date..end_date).each { |d|
			if d.wday == 0
				booking1 = Booking.new
				booking1.deputation_id = @deputation.id
				booking1.date_of = d
				booking1.meridian = 'am'
				booking1.save
				booking2 = Booking.new
				booking2.deputation_id = @deputation.id
				booking2.date_of = d
				booking2.meridian = 'pm'
				booking2.save
			else 
				booking1 = Booking.new
				booking1.deputation_id = @deputation.id
				booking1.date_of = d
				booking1.meridian = 'pm'
				booking1.save
			end
		}

        flash[:notice] = 'Deputation was successfully created.'
        format.html { redirect_to(@deputation) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /deputations/1
  def update
    @deputation = Deputation.find(params[:id])

    @admin_menu = true

    respond_to do |format|
      if @deputation.update_attributes(params[:deputation])
        flash[:notice] = 'Deputation was successfully updated.'
        format.html { redirect_to(@deputation) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /deputations/1
#  def destroy
#    @deputation = Deputation.find(params[:id])
#    @deputation.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(deputations_url) }
#    end

end
