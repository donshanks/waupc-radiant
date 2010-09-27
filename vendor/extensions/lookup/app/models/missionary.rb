class Missionary < ActiveRecord::Base
	has_many :deputations
	validates_presence_of :name, :labor

	# email
	validates_format_of :email, 
		:with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i,
		:if => :email?

	# website
	validates_format_of :website, 
		:with => /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix,
		:if => :website?

	def deputations
		Deputation.find(:all, :conditions => ["missionary_id = ?",id])
	end

	def name
		"#{firstname} #{lastname}"
	end

  def name_with_title
    "Rev. #{firstname} #{lastname}"
  end

	def future_deputations
		Deputation.find(:all, :conditions => ["date_end >= CURRENT_DATE AND missionary_id = ?",id])
	end

end
