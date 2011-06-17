class Minister < ActiveRecord::Base

  def bio
    MinisterBio.find(:first, :conditions => ['id = ?',bio_id])
  end

  def roles
    MinisterRole.find(:all, :conditions => ['bio_id = ?',bio_id])
  end

  def full_name_with_title
    "Rev. #{firstname} #{lastname}"
  end

  def full_name
    "#{firstname} #{lastname}"
  end

end
