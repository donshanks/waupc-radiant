class Admin::MissionariesController < ApplicationController
  layout "fhview"
  before_filter :login_required 

  # GET /missionaries
  def index

    @admin_menu = true

		sortby = (params[:sort] == 'labor') ? 'labor' : 'lastname'
	
		if params[:sort] == 'scheduled'
				@missionaries = Missionary.paginate_by_sql [
						'SELECT m.*
						 FROM missionaries m, deputations d 
						 WHERE m.id = d.missionary_id 
						   AND d.date_end >= CURRENT_DATE
						 ORDER BY lastname ASC'
					],
					:page => params[:page], 
					:per_page => 16 
		else 
				@missionaries = Missionary.paginate :page => params[:page], 
					:per_page => 16, 
					:order => sortby + ' ASC'
		end

    respond_to do |format|
      format.html # index.html.erb
    end

  end

  # GET /missionaries/1
  def show
    @missionary = Missionary.find(params[:id])

    @admin_menu = true

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /missionaries/new
  def new
    @missionary = Missionary.new

    @admin_menu = true

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /missionaries/1/edit
  def edit
    @missionary = Missionary.find(params[:id])

    @admin_menu = true

  end

  # POST /missionaries
  def create
    @missionary = Missionary.new(params[:missionary])

    @admin_menu = true

    respond_to do |format|
      if @missionary.save
        flash[:notice] = 'Missionary was successfully created.'
        format.html { redirect_to(@missionary) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /missionaries/1
  def update
    @missionary = Missionary.find(params[:id])

    @admin_menu = true

    respond_to do |format|
      if @missionary.update_attributes(params[:missionary])
        flash[:notice] = 'Missionary was successfully updated.'
        format.html { redirect_to(@missionary) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /missionaries/1
#  def destroy
#    @missionary = Missionary.find(params[:id])
#    @missionary.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(missionaries_url) }
#    end
#  end

  def auto_complete_for_missionary_contains
  	search = params[:missionary][:contains]
		@missionaries = Missionary.find(:all, 
			:conditions => [ 'LOWER(lastname) LIKE ?', '%' + search.downcase + '%' ],
			:order => 'lastname ASC') unless search.blank?
		render :partial => "live"
  end

end
