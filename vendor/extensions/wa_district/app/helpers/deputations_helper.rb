module DeputationsHelper

  def church_name(church_id)
    Church.find(church_id).church_name
  end

  def pastor_of_church(church_id)
    church = Church.find(church_id)
    if church.minister_id.nil? or church.minister_id == 0 then
      "Rev. #{church.pastor}"
    else
       church.minister.full_name_with_title
    end
  end
  
end
